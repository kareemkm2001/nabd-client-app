import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/theme/app_text_styles.dart';
import 'package:nabd_client_app/core/widgets/app_button.dart';
import 'package:nabd_client_app/core/widgets/app_text.dart';

import '../../../../core/localization/app_localization.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/country_picker.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/phone_text_field.dart';
import 'otp_screen.dart';

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

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  late final AuthCubit _cubit;
  late final AnimationController _entryController;
  late final Animation<double> _iconOpacity;
  late final Animation<double> _iconScale;
  late final Animation<double> _cardOpacity;
  late final Animation<Offset> _cardSlide;
  String? _lastNavigatedFullPhone;

  @override
  void initState() {
    super.initState();
    _cubit = AuthCubit();
    
    // Set initial values from widget parameters
    if (widget.initialMode != AuthMode.login) {
      _cubit.changeAuthMode(widget.initialMode);
    }
    if (widget.initialPhoneNumber != null) {
      _cubit.updatePhone(widget.initialPhoneNumber!);
    }

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _iconOpacity = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0, 0.45, curve: Curves.easeOut),
    );
    _iconScale = Tween<double>(begin: 0.94, end: 1).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0, 0.55, curve: Curves.easeOutBack),
      ),
    );
    _cardOpacity = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.25, 1, curve: Curves.easeOut),
    );
    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.25, 1, curve: Curves.easeOutCubic),
      ),
    );
    _entryController.forward();
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
    _entryController.dispose();
    _cubit.close();
    _phoneController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>.value(
      value: _cubit,
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          // Sync controllers with state for fields that might be modified (e.g., normalization)
          if (_phoneController.text != state.phone) {
            _phoneController.value = TextEditingValue(
              text: state.phone,
              selection: TextSelection.collapsed(offset: state.phone.length),
            );
          }

          if (state.isOtpSent) {
            final fullPhone = state.fullPhoneNumber;
            if (fullPhone == null) return;
            if (_lastNavigatedFullPhone == fullPhone) return;
            _lastNavigatedFullPhone = fullPhone;
            
            Navigator.of(context).push(
              _buildRoute(
                BlocProvider.value(
                  value: _cubit,
                  child: OtpScreen(phoneNumber: fullPhone),
                ),
              ),
            );
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final isLoading = state.isLoading;
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 24),
                        FadeTransition(
                          opacity: _iconOpacity,
                          child: ScaleTransition(
                            scale: _iconScale,
                            child: Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 420),
                                switchInCurve: Curves.easeInOut,
                                switchOutCurve: Curves.easeInOut,
                                transitionBuilder: (child, animation) {
                                  final slide = Tween<Offset>(
                                    begin: const Offset(0, 0.03),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeInOut,
                                    ),
                                  );
                                  final scale = Tween<double>(
                                    begin: 0.92,
                                    end: 1.0,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeInOutBack,
                                    ),
                                  );
                                  return FadeTransition(
                                    opacity: animation,
                                    child: SlideTransition(
                                      position: slide,
                                      child: ScaleTransition(
                                        scale: scale,
                                        child: child,
                                      ),
                                    ),
                                  );
                                },
                                child: _AuthHeaderIcon(
                                  key: ValueKey<AuthMode>(state.mode),
                                  icon: state.mode == AuthMode.login 
                                      ? Icons.lock_outline_rounded 
                                      : Icons.person_add_alt_1_rounded,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        FadeTransition(
                          opacity: _cardOpacity,
                          child: SlideTransition(
                            position: _cardSlide,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 24,
                                    offset: const Offset(0, 12),
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  AuthToggle(
                                    mode: state.mode,
                                    onModeSelected: (mode) {
                                      if (isLoading) return;
                                      _cubit.changeAuthMode(mode);
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    AppLocalization.t('mental_health_auth_title'),
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.largeBlack,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    AppLocalization.t(
                                      state.mode == AuthMode.login
                                          ? 'login_subtitle'
                                          : 'register_subtitle',
                                    ),
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.mediumGrey,
                                  ),
                                  const SizedBox(height: 22),
                                  _AuthModeFieldsSwitcher(
                                    mode: state.mode,
                                    firstNameController: _firstNameController,
                                    lastNameController: _lastNameController,
                                    onFirstNameChanged: _cubit.updateFirstName,
                                    onLastNameChanged: _cubit.updateLastName,
                                  ),
                                  const SizedBox(height: 16),
                                  PhoneTextField(
                                    titleKey: 'phone',
                                    margin: 16,
                                    controller: _phoneController,
                                    selectedCountry: state.selectedCountry,
                                    errorText: state.phoneErrorMessage,
                                    hintKey: isSaudi
                                        ? 'saudi_phone_hint'
                                        : AppLocalization.t('phone_number_hint'),
                                    onCountryChanged: _cubit.selectCountry,
                                    onChanged: _cubit.updatePhone,
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
                                  const SizedBox(height: 18),
                                  AppButton(
                                    onTap: () {
                                      if(!isLoading){
                                        if (state.mode == AuthMode.login) {
                                          _cubit.login();
                                        } else {
                                          _cubit.register();
                                        }
                                      }
                                    },
                                    margin: 12,
                                    child: isLoading
                                        ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: AppColors.surface
                                            ),
                                          )
                                        : AppText(
                                              jsonKey: state.mode == AuthMode.login ? 'send_code' : 'create_account',
                                              textStyle: AppTextStyles.mediumWhite,
                                        ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
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
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.secondary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: LayoutBuilder(
          builder: (context, _) {
            return Stack(
              alignment: Alignment.center,
              children: [
                AnimatedAlign(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeInOutCubic,
                  alignment:
                      mode == AuthMode.login ? Alignment.centerLeft : Alignment.centerRight,
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
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

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeInOut,
          style: selected ? AppTextStyles.mediumBoldWhite : AppTextStyles.mediumGrey,
          child: Text(label),
        ),
      ),
    );
  }
}

class _AuthModeFieldsSwitcher extends StatelessWidget {
  final AuthMode mode;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final ValueChanged<String> onFirstNameChanged;
  final ValueChanged<String> onLastNameChanged;

  const _AuthModeFieldsSwitcher({
    required this.mode,
    required this.firstNameController,
    required this.lastNameController,
    required this.onFirstNameChanged,
    required this.onLastNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 420),
      reverseDuration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final isRegisterContent = child.key == const ValueKey('register-fields');
        final beginX = isRegisterContent ? 0.1 : -0.1;
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(beginX, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: mode == AuthMode.login
          ? const SizedBox(key: ValueKey('login-empty'))
          : Column(
              key: const ValueKey('register-fields'),
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  titleKey: 'first_name',
                  controller: firstNameController,
                  margin: 16,
                  keyboardType: TextInputType.name,
                  onChanged: onFirstNameChanged,
                ),
                AppTextField(
                  titleKey: 'last_name',
                  controller: lastNameController,
                  margin: 16,
                  keyboardType: TextInputType.name,
                  onChanged: onLastNameChanged,
                ),
              ],
            ),
    );
  }
}

class _AuthHeaderIcon extends StatelessWidget {
  final IconData icon;

  const _AuthHeaderIcon({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      width: 72,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 36,
        color: AppColors.primary,
      ),
    );
  }
}
