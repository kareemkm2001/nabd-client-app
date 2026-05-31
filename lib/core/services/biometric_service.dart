import 'package:local_auth/local_auth.dart';

class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> authenticate() async {
    try {
      final bool isSupported = await _auth.isDeviceSupported();

      print("isSupported: $isSupported");

      if (!isSupported) return false;

      final bool authenticated = await _auth.authenticate(
        localizedReason: 'يرجى التحقق من هويتك',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      print("authenticated: $authenticated");

      return authenticated;
    } catch (e) {
      print('Biometric Error: $e');
      return false;
    }
  }
}