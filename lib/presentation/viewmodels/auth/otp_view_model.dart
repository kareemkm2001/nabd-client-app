import 'package:flutter/foundation.dart';

import '../../../core/services/auth_service.dart';

class OtpViewModel extends ChangeNotifier {
  OtpViewModel({
    AuthService? authService,
  }) : _authService = authService ?? AuthService();

  final AuthService _authService;
  bool isSubmitting = false;

  String? validateOtp(String code) {
    if (code.isEmpty) {
      return 'empty';
    }
    if (code.length != 4) {
      return 'invalid_length_4';
    }
    if (!RegExp(r'^\d+$').hasMatch(code)) {
      return 'invalid_digits';
    }
    return null;
  }

  Future<bool> verifyCode(String code) async {
    isSubmitting = true;
    notifyListeners();
    final result = await _authService.verifyOtp(otpCode: code);
    isSubmitting = false;
    notifyListeners();
    return result;
  }

  Future<bool> resendCode(String phoneNumber) async {
    return _authService.sendOtp(fullPhoneNumber: phoneNumber);
  }
}
