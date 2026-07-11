import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/theme/app_text_styles.dart';
import 'package:nabd_client_app/core/widgets/app_button.dart';
import 'package:nabd_client_app/core/widgets/app_text.dart';
import 'package:nabd_client_app/domain/models/auth/register_request_model.dart';
import 'package:nabd_client_app/presentation/profile/widgets/app_text_field.dart';

import '../../../../core/localization/app_localization.dart';
import '../../../core/widgets/app_route_animation.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../../core/widgets/top_snackbar.dart';
import '../../profile/widgets/app_country_code_field.dart';
import '../../terms_and_conditions/terms_page.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
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

  late final AnimationController _entryController;
  late final Animation<double> _iconOpacity;
  late final Animation<double> _iconScale;
  late final Animation<double> _cardOpacity;
  late final Animation<Offset> _cardSlide;


  @override
  void initState() {
    super.initState();
    final cubit = context.read<AuthCubit>();

    // Set initial values from widget parameters
    if (widget.initialMode != AuthMode.login) {
      cubit.changeAuthMode(widget.initialMode);
    }
    if (widget.initialPhoneNumber != null) {
      cubit.updatePhone(widget.initialPhoneNumber!);
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

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>() ;
    return BlocListener<AuthCubit,AuthState>(
      listener: (context, state) {
        if (state is RequestOTPLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const LoadingOverlay(),
          );
        }

        if (state is RequestOtpSuc) {
          Navigator.of(context, rootNavigator: true).pop();

          showAppSnackBarSuc(
            context: context,
            message: state.sucMsg,
          );

          Navigator.push(
            context,
            AppRouteAnimation(
              page: OtpScreen(),
            ),
          );
        }

        if (state is RequestOTPError) {
          Navigator.of(context, rootNavigator: true).pop();

          showAppSnackBarError(
            context: context,
            message: state.errorMsg,
          );
        }
      },
      child: BlocProvider<AuthCubit>.value(
        value: authCubit,
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            // Sync controllers with state for fields that might be modified (e.g., normalization)
            if (authCubit.phoneController.text != state.phone) {
              authCubit.phoneController.value = TextEditingValue(
                text: state.phone,
                selection: TextSelection.collapsed(offset: state.phone.length),
              );
            }
          },
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              var isLoading = state.isLoading;
              final isSaudi = state.selectedCountry.dialCode == '+966';
              final String? inlineError = (state.errorMessage != null &&
                      state.errorMessage != state.phoneErrorMessage)
                  ? state.errorMessage
                  : null;
      
              return Scaffold(
                backgroundColor: AppColors.background,
                appBar: null,
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
                                        authCubit.changeAuthMode(mode);
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
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        AppCountryCodeField(
                                          controller: authCubit.countryCodeController,
                                          onChanged: (code){
                                            authCubit.countryCode = int.parse(code) ;
                                            print("كود الدوله $code");
                                          },
                                        ),
      
                                        const SizedBox(width: 12),
      
                                        Expanded(
                                          child: AppTextField(
                                            title: "رقم الهاتف",
                                            controller: authCubit.phoneController,
                                            icon: Icons.mobile_friendly_sharp,
                                            keyboardType: TextInputType.phone,
                                            minLength: 7,
                                            maxLength: 11,
                                            validator: (value) {
                                              if (value == null || value.length < 7) {
                                                return "رقم الهاتف غير صحيح";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    _AuthModeFieldsSwitcher(
                                      authCubit: authCubit,
                                      mode: state.mode,
                                      firstNameController: authCubit.firstNameController,
                                      lastNameController: authCubit.lastNameController,
                                      onFirstNameChanged: authCubit.updateFirstName,
                                      onLastNameChanged: authCubit.updateLastName,
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
                                        authCubit.phoneNum = authCubit.phoneController.text ;
                                        if (state.mode == AuthMode.login) {
                                          if(authCubit.phoneController.text.isEmpty || authCubit.phoneController.text.length < 8){
                                            showAppSnackBarError(context: context, message: "يرجي ادخال رقم هاتف صحيح");
                                          }else {
                                            authCubit.requestOTO(context: context, mobile: authCubit.phoneController.text);
                                          }
                                        } else {
                                          if(
                                            authCubit.phoneController.text.length > 7 &&
                                            authCubit.firstNameController.text.isNotEmpty &&
                                            authCubit.lastNameController.text.isNotEmpty &&
                                            authCubit.isTermsAccepted == true
                                          ){
                                            authCubit.phoneNum = authCubit.phoneController.text ;
                                            authCubit.register(
                                                context: context,
                                                registerRequestModel: RegisterRequestModel(
                                                    firstName: authCubit.firstNameController.text,
                                                    lastName: authCubit.lastNameController.text,
                                                    mobile: authCubit.phoneController.text,
                                                    contryCode: authCubit.countryCode.toString(),
                                                    termsConditions: "1"
                                                )
                                            );
                                          }else {
                                            showAppSnackBarError(context: context, message: "يرجي اكمال جميع البينات");
                                          }
                                        }
                                      },
                                      margin: 12,
                                      child: AppText(
                                        jsonKey: state.mode == AuthMode.login ? 'send_code' : 'create_account',
                                        textStyle: AppTextStyles.mediumWhite,
                                      )
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
class _AuthModeFieldsSwitcher extends StatefulWidget {
  final AuthCubit authCubit ;
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
    required this.authCubit
  });

  @override
  State<_AuthModeFieldsSwitcher> createState() =>
      _AuthModeFieldsSwitcherState();
}

class _AuthModeFieldsSwitcherState extends State<_AuthModeFieldsSwitcher> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 420),
      reverseDuration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final isRegisterContent =
            child.key == const ValueKey('register-fields');

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
      child: widget.mode == AuthMode.login
          ? const SizedBox(key: ValueKey('login-empty'))
          : Column(
        key: const ValueKey('register-fields'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          AppTextField(
            controller: widget.authCubit.firstNameController,
            title: "الاسم الاول",
            icon: Icons.person_outline,
          ),

          AppTextField(
            controller: widget.authCubit.lastNameController,
            title: "اسم العائلة",
            icon: Icons.person_outline,
          ),

          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: widget.authCubit.isTermsAccepted,
                onChanged: (value) {
                  setState(() {
                    widget.authCubit.isTermsAccepted = value ?? false;
                  });
                },
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Wrap(
                    children: [
                      const Text(
                        "أنا أوافق على ",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                        ),
                      ),

                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TermsPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "الشروط والأحكام",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
