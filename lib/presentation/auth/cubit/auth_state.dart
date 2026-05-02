import 'package:nabd_client_app/core/widgets/country_picker.dart';

enum AuthMode { login, register }

class AuthState {
  final AuthMode mode;
  final Country selectedCountry;
  final String phone;
  final String firstName;
  final String lastName;
  final String password;
  final String otp;
  final bool isLoading;
  final String? phoneErrorMessage;
  final String? errorMessage;
  final String? fullPhoneNumber;
  final bool isOtpSent;
  final bool isVerified;

  const AuthState({
    this.mode = AuthMode.login,
    this.selectedCountry = const Country(
      nameKey: 'country_saudi_arabia',
      dialCode: '+966',
      flag: '🇸🇦',
    ),
    this.phone = '',
    this.firstName = '',
    this.lastName = '',
    this.password = '',
    this.otp = '',
    this.isLoading = false,
    this.phoneErrorMessage,
    this.errorMessage,
    this.fullPhoneNumber,
    this.isOtpSent = false,
    this.isVerified = false,
  });

  AuthState copyWith({
    AuthMode? mode,
    Country? selectedCountry,
    String? phone,
    String? firstName,
    String? lastName,
    String? password,
    String? otp,
    bool? isLoading,
    String? phoneErrorMessage,
    String? errorMessage,
    String? fullPhoneNumber,
    bool? isOtpSent,
    bool? isVerified,
  }) {
    return AuthState(
      mode: mode ?? this.mode,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      phone: phone ?? this.phone,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      password: password ?? this.password,
      otp: otp ?? this.otp,
      isLoading: isLoading ?? this.isLoading,
      phoneErrorMessage: phoneErrorMessage ?? this.phoneErrorMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      fullPhoneNumber: fullPhoneNumber ?? this.fullPhoneNumber,
      isOtpSent: isOtpSent ?? this.isOtpSent,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
