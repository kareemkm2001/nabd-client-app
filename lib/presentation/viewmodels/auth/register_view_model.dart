import 'package:flutter/foundation.dart';

import '../../../core/services/auth_service.dart';

class RegisterViewModel extends ChangeNotifier {
  RegisterViewModel({
    AuthService? authService,
  }) : _authService = authService ?? AuthService();

  final AuthService _authService;
  bool isSubmitting = false;

  String? validateName(String value) {
    if (value.trim().isEmpty) {
      return 'empty';
    }
    if (value.trim().length < 2) {
      return 'too_short';
    }
    return null;
  }

  Future<bool> createAccount({
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    isSubmitting = true;
    notifyListeners();
    final result = await _authService.createAccount(
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      phoneNumber: phoneNumber,
    );
    isSubmitting = false;
    notifyListeners();
    return result;
  }
}
