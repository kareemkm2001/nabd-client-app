import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:nabd_client_app/core/localization/app_localization.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/theme/app_text_styles.dart';
import 'package:nabd_client_app/core/widgets/app_button.dart';
import 'package:nabd_client_app/domain/models/auth/verify_Otp_request_model.dart';
import 'package:nabd_client_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:nabd_client_app/presentation/auth/cubit/auth_state.dart';
import 'package:nabd_client_app/presentation/auth/widgets/resend_timer.dart';

import '../../../core/services/local_notification_service.dart';
import '../../../core/widgets/app_route_animation.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../../core/widgets/top_snackbar.dart';
import '../../main_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});


  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const int _otpLength = 4;


  @override
  Widget build(BuildContext context) {

    final authCubit = context.read<AuthCubit>() ;

    return BlocListener<AuthCubit,AuthState>(
      listener: (context, state) async {
        if (state is LoginLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const LoadingOverlay(),
          );
        }

        if (state is LoginSuc) {
          Navigator.of(context, rootNavigator: true).pop();
          await LocalNotificationService.show(
            title: "أهلًا بك في التطبيق 👋",
            body: "تم تسجيل الدخول بنجاح، نتمنى لك تجربة مميزة",
          );
          showAppSnackBarSuc(
            context: context,
            message: state.sucMsg,
          );
          Navigator.pushAndRemoveUntil(
            context,
            AppRouteAnimation(page: const MainScreen()),
                (route) => false,
          );
        }

        if (state is LoginError) {
          Navigator.of(context, rootNavigator: true).pop();

          showAppSnackBarError(
            context: context,
            message: state.errorMsg,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Center(
                    child: Container(
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textPrimary.withValues(alpha: 0.06),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.verified_user_rounded,
                        size: 36,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          AppLocalization.t('otp_verify_title'),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.largeBlack,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalization.t('otp_verify_subtitle'),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.mediumGrey,
                        ),
                        const SizedBox(height: 32),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: OtpTextField(
                            numberOfFields: _otpLength,
                            fieldWidth: 52,
                            fieldHeight: 52,
                            borderRadius: BorderRadius.circular(8),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            showFieldAsBox: true,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            borderColor: AppColors.secondary,
                            disabledBorderColor: AppColors.secondary,
                            focusedBorderColor: AppColors.primary,
                            enabledBorderColor: AppColors.secondary,
                            cursorColor: AppColors.primary,
                            textStyle: AppTextStyles.mediumBlack,
                            keyboardType: TextInputType.number,
                            onCodeChanged: (code) {
                              authCubit.otpCode = code ;
                            },
                            onSubmit: (verificationCode) {
                              authCubit.otpCode = verificationCode;
                            },
                          ),
                        ),
                        //ResendTimerWidget(),
                        const SizedBox(height: 18),
                        AppButton(
                          onTap: (){
                            context.read<AuthCubit>().login(
                                verifyOtpRequestModel: VerifyOtpRequestModel(
                                    mobile: authCubit.phoneNum.toString(),
                                    otp: authCubit.otpCode
                                )
                            );
                          },
                          margin: 12,
                          titleKey: 'verify',
                        ),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            "+${authCubit.countryCode}${authCubit.phoneNum}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
