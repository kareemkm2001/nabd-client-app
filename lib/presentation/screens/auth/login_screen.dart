import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nabd_client_app/presentation/screens/auth/phone_text_field.dart';

import '../../../core/localization/app_localization.dart';
import '../../viewmodels/auth/login_view_model.dart';
import '../../widgets/country_picker.dart';
import 'otp_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  late final LoginViewModel _viewModel;
  String? _phoneErrorText;

  @override
  void initState() {
    super.initState();
    _viewModel = LoginViewModel();
    _viewModel.addListener(_viewModelListener);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_viewModelListener);
    _viewModel.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _viewModelListener() {
    if (mounted) {
      final normalized = _viewModel.normalizeInput(_phoneController.text);
      if (_phoneController.text != normalized) {
        _phoneController.value = TextEditingValue(
          text: normalized,
          selection: TextSelection.collapsed(offset: normalized.length),
        );
      }
      _phoneErrorText = _mapPhoneError(_viewModel.validatePhone(_phoneController.text));
      setState(() {});
    }
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final fullPhone = _viewModel.buildFullPhoneNumber(_phoneController.text);
    final sent = await _viewModel.sendCode(fullPhone);
    if (!mounted || !sent) {
      return;
    }

    Navigator.of(context).push(_buildRoute(OtpScreen(phoneNumber: fullPhone)));
  }

  PageRouteBuilder<void> _buildRoute(Widget child) {
    return PageRouteBuilder<void>(
      pageBuilder: (_, __, ___) => child,
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
    );
  }

  String? _mapPhoneError(String? errorCode) {
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

  @override
  Widget build(BuildContext context) {
    final isSaudi = _viewModel.isSaudi;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 80),
                const FlutterLogo(size: 72),
                const SizedBox(height: 16),
                Text(
                  AppLocalization.t('mental_health_auth_title'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalization.t('login_subtitle'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 28),
                PhoneTextField(
                  controller: _phoneController,
                  selectedCountry: _viewModel.selectedCountry,
                  errorText: _phoneErrorText,
                  hint: isSaudi ? '5XXXXXXXX' : AppLocalization.t('phone_number_hint'),

                  onCountryTap: _showCountryPickerSheet,

                  onChanged: (value) {
                    final normalized = _viewModel.normalizeInput(value);

                    if (value != normalized) {
                      _phoneController.value = TextEditingValue(
                        text: normalized,
                        selection: TextSelection.collapsed(
                          offset: normalized.length,
                        ),
                      );
                    }

                    setState(() {
                      _phoneErrorText =
                          _mapPhoneError(_viewModel.validatePhone(normalized));
                    });
                  },
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _viewModel.isSubmitting ? null : _sendOtp,
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
                      : Text(AppLocalization.t('send_code')),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    final fullPhone = _viewModel.buildFullPhoneNumber(_phoneController.text);
                    Navigator.of(context).push(_buildRoute(RegisterScreen(phoneNumber: fullPhone)));
                  },
                  child: Text(AppLocalization.t('signup_cta')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showCountryPickerSheet() async {
    final selected = await showModalBottomSheet<Country>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: ListView.builder(
            itemCount: CountryPicker.countries.length,
            itemBuilder: (context, index) {
              final country = CountryPicker.countries[index];
              return ListTile(
                title: Text('${country.flag} ${country.name}'),
                trailing: Text(country.dialCode),
                onTap: () => Navigator.of(context).pop(country),
              );
            },
          ),
        );
      },
    );

    if (selected == null) {
      return;
    }

    _viewModel.selectCountry(selected);
    final normalized = _viewModel.normalizeInput(_phoneController.text);
    _phoneController.value = TextEditingValue(
      text: normalized,
      selection: TextSelection.collapsed(offset: normalized.length),
    );
    setState(() {
      _phoneErrorText = _mapPhoneError(_viewModel.validatePhone(normalized));
    });
  }
}
