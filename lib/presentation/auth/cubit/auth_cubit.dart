import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_client_app/core/localization/app_localization.dart';
import 'package:nabd_client_app/core/services/auth_service.dart';
import 'package:nabd_client_app/core/widgets/country_picker.dart';
import '../../../domain/usecases/auth_use_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthUseCase authUseCase;

  AuthCubit(this.authUseCase) : super(const AuthState());


  bool _hasEditedPhone = false;

  void updatePhone(String value) {
    _hasEditedPhone = true;
    final normalized = _normalizePhoneInput(value);
    final phoneError = _validatePhone(normalized);
    
    emit(state.copyWith(
      phone: normalized,
      phoneErrorMessage: phoneError,
      errorMessage: null,
    ));
  }

  void updateFirstName(String value) {
    emit(state.copyWith(firstName: value.trim(), errorMessage: null));
  }

  void updateLastName(String value) {
    emit(state.copyWith(lastName: value.trim(), errorMessage: null));
  }

  void updatePassword(String value) {
    emit(state.copyWith(password: value, errorMessage: null));
  }

  void updateOtp(String value) {
    emit(state.copyWith(otp: value, errorMessage: null));
  }

  void selectCountry(Country country) {
    if (country == state.selectedCountry) return;
    final normalized = _normalizePhoneInput(state.phone, country: country);
    final phoneError = _hasEditedPhone ? _validatePhone(normalized, country: country) : null;

    emit(state.copyWith(
      selectedCountry: country,
      phone: normalized,
      phoneErrorMessage: phoneError,
    ));
  }

  void changeAuthMode(AuthMode mode) {
    emit(state.copyWith(
      mode: mode,
      errorMessage: null,
      phoneErrorMessage: _hasEditedPhone ? state.phoneErrorMessage : null,
    ));
  }

  Future<void> login() async {
    final phoneError = _validatePhone(state.phone);

    if (phoneError != null) {
      emit(state.copyWith(phoneErrorMessage: phoneError, errorMessage: phoneError));
      return;
    }

    await _sendOtp();
  }

  Future<void> register() async {
    final phoneError = _validatePhone(state.phone);
    if (phoneError != null) {
      emit(state.copyWith(phoneErrorMessage: phoneError, errorMessage: phoneError));
      return;
    }

    if (state.firstName.isEmpty || state.lastName.isEmpty) {
      emit(state.copyWith(errorMessage: AppLocalization.t('name_required')));
      return;
    }

    final fullPhone = _buildFullPhoneNumber(state.phone);
    emit(state.copyWith(isLoading: true, errorMessage: null, fullPhoneNumber: fullPhone));



    if (isClosed) return;


  }

  Future<void> verifyOtp() async {
    final otp = state.otp.trim();
    if (otp.length != 4) {
      emit(state.copyWith(errorMessage: AppLocalization.t('otp_validation')));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    if (isClosed) return;


  }

  Future<void> resendOtp() async {
    if (state.fullPhoneNumber == null) return;
    await _sendOtp();
  }

  Future<void> _sendOtp() async {
    final fullPhone = _buildFullPhoneNumber(state.phone);
    emit(state.copyWith(
      isLoading: true, 
      errorMessage: null, 
      fullPhoneNumber: fullPhone, 
      isOtpSent: false,
    ));

    if (isClosed) return;


  }

  // --- Helper Methods ---

  String _normalizePhoneInput(String rawPhone, {Country? country}) {
    final c = country ?? state.selectedCountry;
    var digitsOnly = rawPhone.replaceAll(RegExp(r'\D'), '');

    if (c.dialCode == '+966') {
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

  String _buildFullPhoneNumber(String localDigits, {Country? country}) {
    final c = country ?? state.selectedCountry;
    return '${c.dialCode}${localDigits.trim()}';
  }

  String? _validatePhone(String phoneDigits, {Country? country}) {
    final c = country ?? state.selectedCountry;
    final digits = phoneDigits.trim();

    if (digits.isEmpty) return AppLocalization.t('phone_required');

    if (c.dialCode == '+966') {
      if (!digits.startsWith('5')) return AppLocalization.t('saudi_phone_start');
      if (digits.length != 9) return AppLocalization.t('saudi_phone_length');
      if (!RegExp(r'^\d{9}$').hasMatch(digits)) return AppLocalization.t('phone_validation');
      return null;
    }

    if (!RegExp(r'^\d{6,10}$').hasMatch(digits)) return AppLocalization.t('phone_validation');
    return null;
  }

  void requestOTO() async {
    print("صفحة الكيوبت");
    final result = await authUseCase.requestOTP("530572149");
    result.fold((l) => print(l.message), (r) => print(r));
  }


}
