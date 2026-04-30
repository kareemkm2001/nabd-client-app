import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';

import '../../../../core/localization/app_localization.dart';
import '../../../../core/widgets/app_text_field.dart';

import '../../../core/widgets/country_picker.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'otp_screen.dart';
import '../widgets/phone_text_field.dart';

class AuthScreen extends StatefulWidget {
  final AuthMode initialMode;
  final String? initialPhoneNumber;

  const AuthScreen({
    super.key,
    this.initialMode = AuthMode.login,
    this.initialPhoneNumber,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _phoneController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  late final AuthCubit _cubit;
  String? _lastNavigatedFullPhone;

  @override
  void initState() {
    super.initState();
    _cubit = AuthCubit(
      initialMode: widget.initialMode,
      initialFullPhoneNumber: widget.initialPhoneNumber,
    );
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

  @override
  void dispose() {
    _cubit.close();
    _phoneController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
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
    _cubit.selectCountry(selected);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>.value(
      value: _cubit,
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          // Keep controller synced with cubit normalization.
          if (_phoneController.text != state.phone) {
            _phoneController.value = TextEditingValue(
              text: state.phone,
              selection:
                  TextSelection.collapsed(offset: state.phone.length),
            );
          }

          // Navigate to OTP step when cubit confirms OTP send success.
          if (state is AuthOtpSentSuccess) {
            final fullPhone = state.fullPhoneNumber;
            if (fullPhone == null) return;
            if (_lastNavigatedFullPhone == fullPhone) return;
            _lastNavigatedFullPhone = fullPhone;
            Navigator.of(context).push(
              _buildRoute(
                BlocProvider.value(
                  value: context.read<AuthCubit>(),
                  child: OtpScreen(phoneNumber: fullPhone),
                ),
              ),
            );
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            final isSaudi = state.selectedCountry.dialCode == '+966';

            final String? inlineError = (state.errorMessage != null &&
                    state.errorMessage != state.phoneErrorMessage)
                ? state.errorMessage
                : null;

            return Scaffold(
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 12),
                        AuthToggle(
                          mode: state.mode,
                          onModeSelected: (mode) {
                            if (isLoading) return;
                            _cubit.changeAuthMode(mode);
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
                            state.mode == AuthMode.login
                                ? 'login_subtitle'
                                : 'register_subtitle',
                          ),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),

                        const SizedBox(height: 28),

                        PhoneTextField(
                          controller: _phoneController,
                          selectedCountry: state.selectedCountry,
                          errorText: state.phoneErrorMessage,
                          hint: isSaudi
                              ? '5XXXXXXXX'
                              : AppLocalization.t('phone_number_hint'),
                          onCountryTap: _showCountryPickerSheet,
                          onChanged: (value) {
                            if (value == _cubit.state.phone) return;
                            _cubit.onPhoneChanged(value);
                          },
                        ),

                        if (inlineError != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            inlineError,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],

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
                          child: state.mode == AuthMode.login
                              ? _LoginActions(
                                  key: const ValueKey('loginActions'),
                                  isSubmitting: isLoading,
                                  onPressed: () {
                                    _cubit.login(_phoneController.text);
                                  },
                                )
                              : _RegisterActions(
                                  key: const ValueKey('registerActions'),
                                  isSubmitting: isLoading,
                                  firstNameController: _firstNameController,
                                  lastNameController: _lastNameController,
                                  onPressed: () {
                                    _cubit.register(
                                      firstName: _firstNameController.text,
                                      lastName: _lastNameController.text,
                                      phone: _phoneController.text,
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
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

  const _RegisterActions({
    super.key,
    required this.onPressed,
    required this.isSubmitting,
    required this.firstNameController,
    required this.lastNameController,
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
        ),
        AppTextField(
          titleKey: 'last_name',
          controller: lastNameController,
          margin: 0,
          keyboardType: TextInputType.name,
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

