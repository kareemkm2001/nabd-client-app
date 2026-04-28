import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/localization/app_localization.dart';
import '../../viewmodels/auth/otp_view_model.dart';
import '../home/home_screen.dart';

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
  final TextEditingController _otpController = TextEditingController();
  late final OtpViewModel _viewModel;
  String? _inlineError;

  @override
  void initState() {
    super.initState();
    _viewModel = OtpViewModel();
    _viewModel.addListener(_viewModelListener);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_viewModelListener);
    _viewModel.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _viewModelListener() {
    if (mounted) {
      setState(() {});
    }
  }

  String? _mapOtpError(String? errorCode) {
    switch (errorCode) {
      case 'empty':
        return AppLocalization.t('otp_required');
      case 'invalid_length_4':
        return AppLocalization.t('otp_validation');
      case 'invalid_digits':
        return AppLocalization.t('otp_digits_only');
      default:
        return null;
    }
  }

  Future<void> _verify() async {
    final code = _otpController.text.trim();
    final error = _mapOtpError(_viewModel.validateOtp(code));
    if (error != null) {
      setState(() {
        _inlineError = error;
      });
      return;
    }

    setState(() {
      _inlineError = null;
    });

    final isValid = await _viewModel.verifyCode(code);
    if (!mounted || !isValid) {
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => const HomeScreen(),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.t('otp_verification')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalization.t('otp_sent_to'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              widget.phoneNumber,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Directionality(
              textDirection: TextDirection.ltr,
              child: TextField(
                controller: _otpController,
                autofocus: true,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                decoration: InputDecoration(
                  hintText: '0000',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _inlineError = _mapOtpError(_viewModel.validateOtp(value));
                  });
                  if (value.length == 4) {
                    _verify();
                  }
                },
              ),
            ),
            if (_inlineError != null) ...[
              const SizedBox(height: 8),
              Text(
                _inlineError!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _viewModel.isSubmitting ? null : _verify,
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
                  : Text(AppLocalization.t('confirm')),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () async {
                await _viewModel.resendCode(widget.phoneNumber);
                if (!mounted) {
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalization.t('code_resent'))),
                );
              },
              child: Text(AppLocalization.t('resend_code')),
            ),
          ],
        ),
      ),
    );
  }
}
