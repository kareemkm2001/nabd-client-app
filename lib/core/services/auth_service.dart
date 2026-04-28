class AuthService {
  Future<bool> sendOtp({
    required String fullPhoneNumber,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    return fullPhoneNumber.isNotEmpty;
  }

  Future<bool> verifyOtp({
    required String otpCode,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    return otpCode.length == 4;
  }

  Future<bool> createAccount({
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    return firstName.isNotEmpty && lastName.isNotEmpty && phoneNumber.isNotEmpty;
  }
}
