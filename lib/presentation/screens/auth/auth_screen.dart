import 'package:flutter/material.dart';

import '../../../core/localization/app_localization.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../viewmodels/auth/login_view_model.dart';
import '../../viewmodels/auth/register_view_model.dart';
import '../../widgets/country_picker.dart';
import 'otp_screen.dart';
import 'widgets/phone_text_field.dart';

enum AuthMode { login, register }

class AuthScreen extends StatefulWidget {
  final AuthMode initialMode;
  final String? initialPhoneNumber; // Full phone number (ex: +9665xxxxxxx)

  const AuthScreen({
    super.key,
    this.initialMode = AuthMode.login,
    this.initialPhoneNumber,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  late final LoginViewModel _loginViewModel;
  late final RegisterViewModel _registerViewModel;

  late AuthMode _mode;

  String? _phoneErrorText;
  bool _phoneTouched = false;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;

    _loginViewModel = LoginViewModel();
    _registerViewModel = RegisterViewModel();

    _loginViewModel.addListener(_viewModelListener);
    _registerViewModel.addListener(_viewModelListener);

    if (widget.initialPhoneNumber != null) {
      _applyInitialPhone(widget.initialPhoneNumber!);
    }
  }

  void _viewModelListener() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _loginViewModel
      ..removeListener(_viewModelListener)
      ..dispose();
    _registerViewModel
      ..removeListener(_viewModelListener)
      ..dispose();

    _phoneController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  bool get _isSubmitting => _loginViewModel.isSubmitting || _registerViewModel.isSubmitting;

  void _applyInitialPhone(String fullPhone) {
    // Parse full phone number into (selected dial code, local digits).
    for (final country in CountryPicker.countries) {
      if (fullPhone.startsWith(country.dialCode)) {
        _loginViewModel.selectCountry(country);
        final localDigits = fullPhone.substring(country.dialCode.length);
        _phoneController.text = _loginViewModel.normalizeInput(localDigits);
        return;
      }
    }

    _phoneController.text = _loginViewModel.normalizeInput(fullPhone);
  }

  String? _mapPhoneError(String? errorCode) {
    switch (errorCode) {
      case 'empty':
        return AppLocalization.t('phone_required');
      case 'saudi_start':
        return AppLocalization.t('saudi_phone_start');
      case 'saudi_length':
        return AppLocalization.t('saudi_phone_length');
      case 'min_length':
      case 'invalid':
        return AppLocalization.t('phone_validation');
      default:
        return null;
    }
  }

  String? _mapNameError(String? errorCode) {
    switch (errorCode) {
      case 'empty':
        return AppLocalization.t('name_required');
      case 'too_short':
        return AppLocalization.t('name_too_short');
      default:
        return null;
    }
  }

  void _onPhoneChanged(String rawValue) {
    _phoneTouched = true;

    final normalized = _loginViewModel.normalizeInput(rawValue);
    if (rawValue != normalized) {
      _phoneController.value = TextEditingValue(
        text: normalized,
        selection: TextSelection.collapsed(offset: normalized.length),
      );
    }

    setState(() {
      _phoneErrorText = _mapPhoneError(_loginViewModel.validatePhone(normalized));
    });
  }

  Future<void> _showCountryPickerSheet() async {
    final selected = await showModalBottomSheet<Country>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: ListView.builder(
            itemCount: CountryPicker.countries.length,
            itemBuilder: (context, index) {
              final country = CountryPicker.countries[index];
              return ListTile(
                title: Text('${country.flag} ${country.name}'),
                trailing: Text(country.dialCode),
                onTap: () => Navigator.of(context).pop(country),
              );
            },
          ),
        );
      },
    );

    if (selected == null || !mounted) return;

    _loginViewModel.selectCountry(selected);

    // Normalize current digits based on the new country rules.
    final normalized = _loginViewModel.normalizeInput(_phoneController.text);
    _phoneController.value = TextEditingValue(
      text: normalized,
      selection: TextSelection.collapsed(offset: normalized.length),
    );

    setState(() {
      _phoneErrorText = _mapPhoneError(_loginViewModel.validatePhone(normalized));
    });
  }

  PageRouteBuilder<void> _buildRoute(Widget child) {
    return PageRouteBuilder<void>(
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, animation, __, page) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: page,
        ),
      ),
    );
  }

  Future<void> _submitLogin() async {
    final raw = _phoneController.text.trim();
    final normalized = _loginViewModel.normalizeInput(raw);
    final phoneError = _mapPhoneError(_loginViewModel.validatePhone(normalized));

    if (phoneError != null) {
      setState(() {
        _phoneTouched = true;
        _phoneErrorText = phoneError;
      });
      return;
    }

    final fullPhone = _loginViewModel.buildFullPhoneNumber(normalized);
    final sent = await _loginViewModel.sendCode(fullPhone);
    if (!mounted || !sent) return;

    Navigator.of(context).push(_buildRoute(OtpScreen(phoneNumber: fullPhone)));
  }

  Future<void> _submitRegister() async {
    final raw = _phoneController.text.trim();
    final normalized = _loginViewModel.normalizeInput(raw);
    final phoneError = _mapPhoneError(_loginViewModel.validatePhone(normalized));

    if (phoneError != null) {
      setState(() {
        _phoneTouched = true;
        _phoneErrorText = phoneError;
      });
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final fullPhone = _loginViewModel.buildFullPhoneNumber(normalized);
    final created = await _registerViewModel.createAccount(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phoneNumber: fullPhone,
    );

    if (!mounted || !created) return;

    Navigator.of(context).push(_buildRoute(OtpScreen(phoneNumber: fullPhone)));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isSaudi = _loginViewModel.isSaudi;

    final phoneErrorToShow = _phoneTouched ? _phoneErrorText : null;

    return Scaffold(
      backgroundColor: cs.surfaceContainerHighest.withValues(alpha: 0.25),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  AuthToggle(
                    mode: _mode,
                    onModeSelected: (mode) {
                      if (_isSubmitting) return;
                      setState(() {
                        _mode = mode;
                      });
                    },
                  ),
                  const SizedBox(height: 28),

                  Text(
                    AppLocalization.t('mental_health_auth_title'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalization.t(
                      _mode == AuthMode.login ? 'login_subtitle' : 'register_subtitle',
                    ),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 28),

                  PhoneTextField(
                    controller: _phoneController,
                    selectedCountry: _loginViewModel.selectedCountry,
                    errorText: phoneErrorToShow,
                    hint: isSaudi ? '5XXXXXXXX' : AppLocalization.t('phone_number_hint'),
                    onCountryTap: _showCountryPickerSheet,
                    onChanged: _onPhoneChanged,
                  ),

                  const SizedBox(height: 20),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 320),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, animation) {
                      final offsetAnim = Tween<Offset>(
                        begin: const Offset(0.05, 0),
                        end: Offset.zero,
                      ).animate(animation);
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: offsetAnim,
                          child: child,
                        ),
                      );
                    },
                    child: _mode == AuthMode.login
                        ? _LoginActions(
                            key: const ValueKey('loginActions'),
                            isSubmitting: _loginViewModel.isSubmitting,
                            onPressed: _submitLogin,
                          )
                        : _RegisterActions(
                            key: const ValueKey('registerActions'),
                            isSubmitting: _registerViewModel.isSubmitting,
                            firstNameController: _firstNameController,
                            lastNameController: _lastNameController,
                            nameErrorMapper: _mapNameError,
                            validateName: _registerViewModel.validateName,
                            onPressed: _submitRegister,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthToggle extends StatelessWidget {
  final AuthMode mode;
  final ValueChanged<AuthMode> onModeSelected;

  const AuthToggle({
    super.key,
    required this.mode,
    required this.onModeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeInOut,
                alignment:
                    mode == AuthMode.login ? Alignment.centerLeft : Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _ToggleTab(
                      label: AppLocalization.t('login'),
                      selected: mode == AuthMode.login,
                      onTap: () => onModeSelected(AuthMode.login),
                    ),
                  ),
                  Expanded(
                    child: _ToggleTab(
                      label: AppLocalization.t('register'),
                      selected: mode == AuthMode.register,
                      onTap: () => onModeSelected(AuthMode.register),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ToggleTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.labelLarge;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeInOut,
          style: textStyle!.copyWith(
            color: selected ? cs.onPrimary : cs.onSurfaceVariant,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}

class _LoginActions extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isSubmitting;

  const _LoginActions({
    super.key,
    required this.onPressed,
    required this.isSubmitting,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          onPressed: isSubmitting ? null : onPressed,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: isSubmitting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(AppLocalization.t('send_code')),
        ),
      ],
    );
  }
}

class _RegisterActions extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isSubmitting;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final String? Function(String?) nameErrorMapper;
  final String? Function(String) validateName;

  const _RegisterActions({
    super.key,
    required this.onPressed,
    required this.isSubmitting,
    required this.firstNameController,
    required this.lastNameController,
    required this.nameErrorMapper,
    required this.validateName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          titleKey: 'first_name',
          controller: firstNameController,
          margin: 0,
          keyboardType: TextInputType.name,
          validator: (value) => nameErrorMapper(validateName(value ?? '')),
        ),
        AppTextField(
          titleKey: 'last_name',
          controller: lastNameController,
          margin: 0,
          keyboardType: TextInputType.name,
          validator: (value) => nameErrorMapper(validateName(value ?? '')),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: isSubmitting ? null : onPressed,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: isSubmitting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(AppLocalization.t('create_account')),
        ),
      ],
    );
  }
}

