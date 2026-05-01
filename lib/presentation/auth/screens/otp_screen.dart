import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:nabd_client_app/core/localization/app_localization.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/theme/app_text_styles.dart';
import 'package:nabd_client_app/core/widgets/app_button.dart';

import '../../home/screens/home_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const int _otpLength = 4;
  String _otpCode = '';
  String? _errorText;

  @override
  void dispose() {
    super.dispose();
  }

  bool _isOtpValid(String value) {
    return RegExp(r'^\d{4}$').hasMatch(value);
  }

  void _verifyCode() {
    if (_isOtpValid(_otpCode)) {
      setState(() {
        _errorText = null;
      });
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder<void>(
          pageBuilder: (_, __, ___) => HomeScreen(),
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
        (_) => false,
      );
      return;
    }

    setState(() {
      _errorText = AppLocalization.t('otp_validation');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            _otpCode = code;
                            if (_errorText != null) {
                              setState(() {
                                _errorText = null;
                              });
                            }
                          },
                          onSubmit: (verificationCode) {
                            _otpCode = verificationCode;
                          },
                        ),
                      ),
                      if (_errorText != null) ...[
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            _errorText!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.error,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      AppButton(
                        onTap: _verifyCode,
                        margin: 12,
                        titleKey: 'verify',
                      ),
                      Text(
                        widget.phoneNumber,
                        textAlign: TextAlign.center,
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
    );
  }
}
