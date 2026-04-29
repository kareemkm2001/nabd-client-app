import 'package:flutter/material.dart';
import 'package:nabd_client_app/presentation/screens/auth/widgets/phone_text_field.dart';

import '../../../core/localization/app_localization.dart';
import '../../viewmodels/auth/login_view_model.dart';
import '../../viewmodels/auth/register_view_model.dart';
import '../../widgets/country_picker.dart';
import 'otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  final String phoneNumber;

  const RegisterScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  late final RegisterViewModel _viewModel;
  late final LoginViewModel _phoneViewModel;

  late final Country _phoneCountry;
  late final String _localPhoneNumber;

  @override
  void initState() {
    super.initState();

    _viewModel = RegisterViewModel();
    _viewModel.addListener(_viewModelListener);

    _phoneViewModel = LoginViewModel();
    _phoneViewModel.addListener(_viewModelListener);

    final result = _parsePhone(widget.phoneNumber);
    _phoneCountry = result['country'] as Country;
    _localPhoneNumber = result['phone'] as String;

    _phoneViewModel.selectCountry(_phoneCountry);
    _phoneController.text = _phoneViewModel.normalizeInput(_localPhoneNumber);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_viewModelListener);
    _viewModel.dispose();
    _phoneViewModel.removeListener(_viewModelListener);
    _phoneViewModel.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _viewModelListener() {
    if (mounted) {
      setState(() {});
    }
  }

  String? _phoneErrorText;

  bool get isSaudi => _phoneViewModel.isSaudi;

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

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final normalized = _phoneViewModel.normalizeInput(_phoneController.text);
    final phoneError = _mapPhoneError(_phoneViewModel.validatePhone(normalized));
    if (phoneError != null) {
      setState(() => _phoneErrorText = phoneError);
      return;
    }

    final fullPhone = _phoneViewModel.buildFullPhoneNumber(normalized);

    final created = await _viewModel.createAccount(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phoneNumber: fullPhone,
    );
    if (!mounted || !created) {
      return;
    }

    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => OtpScreen(phoneNumber: fullPhone),
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
      ),
    );
  }

  Map<String, dynamic> _parsePhone(String fullPhone) {
    for (final country in CountryPicker.countries) {
      if (fullPhone.startsWith(country.dialCode)) {
        return {
          'country': country,
          'phone': fullPhone.substring(country.dialCode.length),
        };
      }
    }
    return {
      'country': CountryPicker.countries.first,
      'phone': fullPhone,
    };
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

    _phoneViewModel.selectCountry(selected);
    final normalized = _phoneViewModel.normalizeInput(_phoneController.text);
    _phoneController.value = TextEditingValue(
      text: normalized,
      selection: TextSelection.collapsed(offset: normalized.length),
    );

    setState(() {
      _phoneErrorText = _mapPhoneError(_phoneViewModel.validatePhone(normalized));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.t('create_account')),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocalization.t('register_subtitle'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: AppLocalization.t('first_name'),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  validator: (value) => _mapNameError(_viewModel.validateName(value ?? '')),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: AppLocalization.t('last_name'),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  validator: (value) => _mapNameError(_viewModel.validateName(value ?? '')),
                ),
                const SizedBox(height: 12),
                PhoneTextField(
                  controller: _phoneController,
                  selectedCountry: _phoneViewModel.selectedCountry,
                  errorText: _phoneErrorText,
                  hint: isSaudi ? '5XXXXXXXX' : AppLocalization.t('phone_number_hint'),

                  onCountryTap: _showCountryPickerSheet,

                  onChanged: (value) {
                    final normalized = _phoneViewModel.normalizeInput(value);

                    if (value != normalized) {
                      _phoneController.value = TextEditingValue(
                        text: normalized,
                        selection: TextSelection.collapsed(
                          offset: normalized.length,
                        ),
                      );
                    }

                    setState(() {
                      _phoneErrorText = _mapPhoneError(
                        _phoneViewModel.validatePhone(normalized),
                      );
                    });
                  },
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _viewModel.isSubmitting ? null : _createAccount,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _viewModel.isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(AppLocalization.t('create_account')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
