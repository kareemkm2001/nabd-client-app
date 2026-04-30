import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nabd_client_app/core/localization/app_localization.dart';
import 'package:nabd_client_app/core/services/auth_service.dart';
import 'package:nabd_client_app/core/widgets/country_picker.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    AuthMode initialMode = AuthMode.login,
    Country? initialCountry,
    String? initialFullPhoneNumber,
    AuthService? authService,
  })  : _authService = authService ?? AuthService(),
        super(
          AuthInitial(
            mode: initialMode,
            selectedCountry: initialCountry ?? CountryPicker.countries.first,
            phone: '',
            phoneErrorMessage: null,
            fullPhoneNumber: null,
            errorMessage: null,
          ),
        ) {
    if (initialFullPhoneNumber != null && initialFullPhoneNumber.isNotEmpty) {
      setInitialPhoneNumber(initialFullPhoneNumber);
    }
  }

  final AuthService _authService;

  bool _hasEditedPhone = false;

  bool _isSaudi(Country country) => country.dialCode == '+966';

  String normalizePhoneInput(
    String rawPhone, {
    Country? country,
  }) {
    final c = country ?? state.selectedCountry;
    var digitsOnly = rawPhone.replaceAll(RegExp(r'\D'), '');

    if (_isSaudi(c)) {
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

  String buildFullPhoneNumber(
    String localDigits, {
    Country? country,
  }) {
    final c = country ?? state.selectedCountry;
    return '${c.dialCode}${localDigits.trim()}';
  }

  String? _mapPhoneErrorCode(String? errorCode) {
    switch (errorCode) {
      case 'empty':
        return AppLocalization.t('phone_required');
      case 'saudi_start':
        return AppLocalization.t('saudi_phone_start');
      case 'saudi_length':
        return AppLocalization.t('saudi_phone_length');
      case 'min_length':
      case 'invalid':
        return AppLocalization.t('phone_validation');
      default:
        return null;
    }
  }

  String? _mapNameErrorCode(String? errorCode) {
    switch (errorCode) {
      case 'empty':
        return AppLocalization.t('name_required');
      case 'too_short':
        return AppLocalization.t('name_too_short');
      default:
        return null;
    }
  }

  String? _mapOtpErrorCode(String? errorCode) {
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

  String? validatePhone(
    String phoneDigits, {
    Country? country,
  }) {
    // Reuse the existing rule engine to keep messages consistent.
    final errorCode = _validatePhoneErrorCode(phoneDigits, country: country);
    return _mapPhoneErrorCode(errorCode);
  }

  String? _validatePhoneErrorCode(
    String phoneDigits, {
    Country? country,
  }) {
    final c = country ?? state.selectedCountry;
    final digits = phoneDigits.trim();

    if (digits.isEmpty) {
      return 'empty';
    }

    if (_isSaudi(c)) {
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

  String? _validateNames({required String firstName, required String lastName}) {
    final firstErrorCode = _validateNameErrorCode(firstName);
    if (firstErrorCode != null) return _mapNameErrorCode(firstErrorCode);

    final lastErrorCode = _validateNameErrorCode(lastName);
    if (lastErrorCode != null) return _mapNameErrorCode(lastErrorCode);

    return null;
  }

  String? _validateNameErrorCode(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'empty';
    }
    if (trimmed.length < 2) {
      return 'too_short';
    }
    return null;
  }

  String? _validateOtp(String code) {
    final errorCode = _validateOtpErrorCode(code);
    return _mapOtpErrorCode(errorCode);
  }

  String sanitizeOtpInput(String rawValue) {
    return rawValue.replaceAll(RegExp(r'\D'), '');
  }

  List<String> splitOtpDigits(
    String rawValue, {
    int length = 4,
  }) {
    final clean = sanitizeOtpInput(rawValue);
    final result = List<String>.filled(length, '');
    for (var i = 0; i < clean.length && i < length; i++) {
      result[i] = clean[i];
    }
    return result;
  }

  String composeOtp(List<String> digits) {
    return sanitizeOtpInput(digits.join());
  }

  String? _validateOtpErrorCode(String code) {
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

  void changeAuthMode(AuthMode mode) {
    if (mode == state.mode) return;
    emit(
      AuthModeChanged(
        mode: mode,
        selectedCountry: state.selectedCountry,
        phone: state.phone,
        phoneErrorMessage: _hasEditedPhone ? state.phoneErrorMessage : null,
        fullPhoneNumber: state.fullPhoneNumber,
        errorMessage: null,
      ),
    );
  }

  void selectCountry(Country country) {
    if (country == state.selectedCountry) return;

    // Re-normalize existing phone based on new country rules.
    final normalized = normalizePhoneInput(state.phone, country: country);
    final phoneError =
        _hasEditedPhone ? validatePhone(normalized, country: country) : null;

    emit(
      AuthPhoneUpdated(
        mode: state.mode,
        selectedCountry: country,
        phone: normalized,
        phoneErrorMessage: phoneError,
        fullPhoneNumber: state.fullPhoneNumber,
        errorMessage: null,
      ),
    );
  }

  /// Called from UI when user types.
  ///
  /// Returns the normalized digits so the UI can keep the controller in sync.
  String onPhoneChanged(String rawPhone) {
    _hasEditedPhone = true;

    final normalized = normalizePhoneInput(rawPhone);
    final phoneError = validatePhone(normalized);

    emit(
      AuthPhoneUpdated(
        mode: state.mode,
        selectedCountry: state.selectedCountry,
        phone: normalized,
        phoneErrorMessage: phoneError,
        fullPhoneNumber: state.fullPhoneNumber,
        errorMessage: null,
      ),
    );

    return normalized;
  }

  /// Prefill from a full phone number (dial code + local digits).
  ///
  /// This is useful when navigating from legacy screens that already have
  /// a "full phone" string.
  void setInitialPhoneNumber(String fullPhoneNumber) {
    final country = CountryPicker.countries.firstWhere(
      (c) => fullPhoneNumber.startsWith(c.dialCode),
      orElse: () => CountryPicker.countries.first,
    );

    final localDigits = fullPhoneNumber.startsWith(country.dialCode)
        ? fullPhoneNumber.substring(country.dialCode.length)
        : fullPhoneNumber;

    final normalized = normalizePhoneInput(localDigits, country: country);
    final phoneError = null; // don't show until user edits / submits

    emit(
      AuthPhoneUpdated(
        mode: state.mode,
        selectedCountry: country,
        phone: normalized,
        phoneErrorMessage: phoneError,
        fullPhoneNumber: fullPhoneNumber,
        errorMessage: null,
      ),
    );
  }

  Future<void> sendOtp(String phone) async {
    final normalized = normalizePhoneInput(phone);
    final phoneError = validatePhone(normalized);

    if (phoneError != null) {
      emit(
        AuthError(
          mode: state.mode,
          selectedCountry: state.selectedCountry,
          phone: normalized,
          phoneErrorMessage: phoneError,
          fullPhoneNumber: null,
          errorMessage: phoneError,
        ),
      );
      return;
    }

    final fullPhoneNumber = buildFullPhoneNumber(normalized);

    emit(
      AuthLoading(
        mode: state.mode,
        selectedCountry: state.selectedCountry,
        phone: normalized,
        phoneErrorMessage: null,
        fullPhoneNumber: fullPhoneNumber,
        errorMessage: null,
      ),
    );

    final sent = await _authService.sendOtp(fullPhoneNumber: fullPhoneNumber);
    if (!isClosed) {
      if (sent) {
        emit(
          AuthCodeSent(
            mode: state.mode,
            selectedCountry: state.selectedCountry,
            phone: normalized,
            phoneErrorMessage: null,
            fullPhoneNumber: fullPhoneNumber,
            errorMessage: null,
          ),
        );
      } else {
        final message = AppLocalization.t('phone_validation');
        emit(
          AuthOtpSentFailure(
            mode: state.mode,
            selectedCountry: state.selectedCountry,
            phone: normalized,
            phoneErrorMessage: message,
            fullPhoneNumber: fullPhoneNumber,
            errorMessage: message,
          ),
        );
      }
    }
  }

  Future<void> login(String phone) async {
    // In this app, login directly enters the OTP step.
    await sendOtp(phone);
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    final normalized = normalizePhoneInput(phone);
    final phoneError = validatePhone(normalized);
    if (phoneError != null) {
      emit(
        AuthError(
          mode: state.mode,
          selectedCountry: state.selectedCountry,
          phone: normalized,
          phoneErrorMessage: phoneError,
          fullPhoneNumber: null,
          errorMessage: phoneError,
        ),
      );
      return;
    }

    final nameError = _validateNames(firstName: firstName, lastName: lastName);
    if (nameError != null) {
      emit(
        AuthError(
          mode: state.mode,
          selectedCountry: state.selectedCountry,
          phone: normalized,
          phoneErrorMessage: null,
          fullPhoneNumber: null,
          errorMessage: nameError,
        ),
      );
      return;
    }

    final fullPhoneNumber = buildFullPhoneNumber(normalized);

    emit(
      AuthLoading(
        mode: state.mode,
        selectedCountry: state.selectedCountry,
        phone: normalized,
        phoneErrorMessage: null,
        fullPhoneNumber: fullPhoneNumber,
        errorMessage: null,
      ),
    );

    final created = await _authService.createAccount(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: fullPhoneNumber,
    );

    if (isClosed) return;
    if (!created) {
      emit(
        AuthError(
          mode: state.mode,
          selectedCountry: state.selectedCountry,
          phone: normalized,
          phoneErrorMessage: null,
          fullPhoneNumber: null,
          errorMessage: AppLocalization.t('phone_validation'),
        ),
      );
      return;
    }

    // After account creation, move to the OTP step by sending OTP.
    await sendOtp(normalized);
  }

  Future<void> verifyOtp(String code) async {
    final trimmed = code.trim();
    final otpError = _validateOtp(trimmed);
    if (otpError != null) {
      emit(
        AuthError(
          mode: state.mode,
          selectedCountry: state.selectedCountry,
          phone: state.phone,
          phoneErrorMessage: state.phoneErrorMessage,
          fullPhoneNumber: state.fullPhoneNumber,
          errorMessage: otpError,
        ),
      );
      return;
    }

    emit(
      AuthLoading(
        mode: state.mode,
        selectedCountry: state.selectedCountry,
        phone: state.phone,
        phoneErrorMessage: state.phoneErrorMessage,
        fullPhoneNumber: state.fullPhoneNumber,
        errorMessage: null,
      ),
    );

    final ok = await _authService.verifyOtp(otpCode: trimmed);
    if (isClosed) return;

    if (ok) {
      emit(
        AuthVerified(
          mode: state.mode,
          selectedCountry: state.selectedCountry,
          phone: state.phone,
          phoneErrorMessage: state.phoneErrorMessage,
          fullPhoneNumber: state.fullPhoneNumber,
          errorMessage: null,
        ),
      );
    } else {
      emit(
        AuthError(
          mode: state.mode,
          selectedCountry: state.selectedCountry,
          phone: state.phone,
          phoneErrorMessage: state.phoneErrorMessage,
          fullPhoneNumber: state.fullPhoneNumber,
          errorMessage: AppLocalization.t('otp_validation'),
        ),
      );
    }
  }

  Future<void> resendOtp() async {
    final full = state.fullPhoneNumber;
    if (full == null || full.isEmpty) {
      emit(
        AuthError(
          mode: state.mode,
          selectedCountry: state.selectedCountry,
          phone: state.phone,
          phoneErrorMessage: state.phoneErrorMessage,
          fullPhoneNumber: null,
          errorMessage: AppLocalization.t('phone_validation'),
        ),
      );
      return;
    }

    // Keep using AuthLoading/AuthOtpSentSuccess/AuthOtpSentFailure so the UI
    // can react consistently.
    emit(
      AuthLoading(
        mode: state.mode,
        selectedCountry: state.selectedCountry,
        phone: state.phone,
        phoneErrorMessage: state.phoneErrorMessage,
        fullPhoneNumber: full,
        errorMessage: null,
      ),
    );

    final sent = await _authService.sendOtp(fullPhoneNumber: full);
    if (isClosed) return;

    if (sent) {
      emit(
        AuthCodeSent(
          mode: state.mode,
          selectedCountry: state.selectedCountry,
          phone: state.phone,
          phoneErrorMessage: null,
          fullPhoneNumber: full,
          errorMessage: null,
        ),
      );
    } else {
      final message = AppLocalization.t('phone_validation');
      emit(
        AuthOtpSentFailure(
          mode: state.mode,
          selectedCountry: state.selectedCountry,
          phone: state.phone,
          phoneErrorMessage: message,
          fullPhoneNumber: full,
          errorMessage: message,
        ),
      );
    }
  }
}

