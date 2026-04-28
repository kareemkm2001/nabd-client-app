import 'package:flutter/foundation.dart';

import '../../../core/services/auth_service.dart';
import '../../widgets/country_picker.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({
    AuthService? authService,
  }) : _authService = authService ?? AuthService();

  final AuthService _authService;

  Country selectedCountry = CountryPicker.countries.first;
  bool isSubmitting = false;

  void selectCountry(Country country) {
    selectedCountry = country;
    notifyListeners();
  }

  bool get isSaudi => selectedCountry.dialCode == '+966';

  int get maxPhoneLength => isSaudi ? 9 : 10;

  String? validatePhone(String rawPhone) {
    final digits = rawPhone.trim();

    if (digits.isEmpty) {
      return 'empty';
    }

    if (this.isSaudi) {
      if (!digits.startsWith('5')) {
        return 'saudi_start';
      }
      if (digits.length != 9) {
        return 'saudi_length';
      }
      if (!RegExp(r'^\d{9}$').hasMatch(digits)) {
        return 'invalid';
      }
      return null;
    }

    if (!RegExp(r'^\d{6,10}$').hasMatch(digits)) {
      return 'min_length';
    }

    return null;
  }

  String normalizeInput(String rawValue) {
    var digitsOnly = rawValue.replaceAll(RegExp(r'\D'), '');

    if (isSaudi) {
      if (digitsOnly.isNotEmpty && !digitsOnly.startsWith('5')) {
        digitsOnly = '';
      }
      if (digitsOnly.length > 9) {
        digitsOnly = digitsOnly.substring(0, 9);
      }
      return digitsOnly;
    }

    if (digitsOnly.length > 10) {
      digitsOnly = digitsOnly.substring(0, 10);
    }
    return digitsOnly;
  }

  String buildFullPhoneNumber(String rawPhone) {
    return '${selectedCountry.dialCode}${rawPhone.trim()}';
  }

  Future<bool> sendCode(String fullPhoneNumber) async {
    isSubmitting = true;
    notifyListeners();
    final result = await _authService.sendOtp(fullPhoneNumber: fullPhoneNumber);
    isSubmitting = false;
    notifyListeners();
    return result;
  }
}
