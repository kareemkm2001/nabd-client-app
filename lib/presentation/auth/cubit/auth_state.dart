import 'package:nabd_client_app/core/widgets/country_picker.dart';

enum AuthMode { login, register }

/// UI state for the authentication flow.
///
/// The cubit is the single source of truth for:
/// - selected country + phone normalization
/// - validation (phone, names, otp)
/// - async loading and error messages
/// - navigation-triggering success events
sealed class AuthState {
  const AuthState({
    required this.mode,
    required this.selectedCountry,
    required this.phone,
    required this.phoneErrorMessage,
    this.fullPhoneNumber,
    this.errorMessage,
  });

  final AuthMode mode;
  final Country selectedCountry;
  final String phone; // local digits (no dial code)
  final String? phoneErrorMessage;

  /// Last full phone number used for OTP / registration.
  final String? fullPhoneNumber;

  /// General error message for UI display / snackbars.
  final String? errorMessage;
}

class AuthInitial extends AuthState {
  const AuthInitial({
    required super.mode,
    required super.selectedCountry,
    super.phone = '',
    super.phoneErrorMessage,
    super.fullPhoneNumber,
    super.errorMessage,
  });
}

class AuthLoading extends AuthState {
  const AuthLoading({
    required super.mode,
    required super.selectedCountry,
    required super.phone,
    required super.phoneErrorMessage,
    super.fullPhoneNumber,
    super.errorMessage,
  });
}

class AuthModeChanged extends AuthState {
  const AuthModeChanged({
    required super.mode,
    required super.selectedCountry,
    required super.phone,
    required super.phoneErrorMessage,
    super.fullPhoneNumber,
    super.errorMessage,
  });
}

class AuthPhoneUpdated extends AuthState {
  const AuthPhoneUpdated({
    required super.mode,
    required super.selectedCountry,
    required super.phone,
    required super.phoneErrorMessage,
    super.fullPhoneNumber,
    super.errorMessage,
  });
}

/// Successful "OTP step" transition.
class AuthOtpSentSuccess extends AuthState {
  const AuthOtpSentSuccess({
    required super.mode,
    required super.selectedCountry,
    required super.phone,
    required super.phoneErrorMessage,
    required super.fullPhoneNumber,
    super.errorMessage,
  });
}

/// Alias of [AuthOtpSentSuccess] for UI that expects the explicit name.
class AuthCodeSent extends AuthOtpSentSuccess {
  const AuthCodeSent({
    required super.mode,
    required super.selectedCountry,
    required super.phone,
    required super.phoneErrorMessage,
    required super.fullPhoneNumber,
    super.errorMessage,
  });
}

class AuthOtpSentFailure extends AuthState {
  const AuthOtpSentFailure({
    required super.mode,
    required super.selectedCountry,
    required super.phone,
    required super.phoneErrorMessage,
    super.fullPhoneNumber,
    required super.errorMessage,
  });
}

class AuthVerified extends AuthState {
  const AuthVerified({
    required super.mode,
    required super.selectedCountry,
    required super.phone,
    required super.phoneErrorMessage,
    super.fullPhoneNumber,
    super.errorMessage,
  });
}

class AuthError extends AuthState {
  const AuthError({
    required super.mode,
    required super.selectedCountry,
    required super.phone,
    required super.phoneErrorMessage,
    super.fullPhoneNumber,
    required super.errorMessage,
  });
}

