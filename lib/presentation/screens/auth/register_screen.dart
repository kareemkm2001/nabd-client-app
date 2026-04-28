import 'package:flutter/material.dart';

import '../../../core/localization/app_localization.dart';
import '../../viewmodels/auth/register_view_model.dart';
import '../../widgets/country_picker.dart';
import 'otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  final String phoneNumber;

  const RegisterScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  late final RegisterViewModel _viewModel;
  late final Country _phoneCountry;
  late final String _localPhoneNumber;

  @override
  void initState() {
    super.initState();
    _viewModel = RegisterViewModel();
    _viewModel.addListener(_viewModelListener);
    final result = _parsePhone(widget.phoneNumber);
    _phoneCountry = result['country'] as Country;
    _localPhoneNumber = result['phone'] as String;
  }

  @override
  void dispose() {
    _viewModel.removeListener(_viewModelListener);
    _viewModel.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _viewModelListener() {
    if (mounted) {
      setState(() {});
    }
  }

  String? _mapNameError(String? errorCode) {
    switch (errorCode) {
      case 'empty':
        return AppLocalization.t('name_required');
      case 'too_short':
        return AppLocalization.t('name_too_short');
      default:
        return null;
    }
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final created = await _viewModel.createAccount(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phoneNumber: widget.phoneNumber,
    );
    if (!mounted || !created) {
      return;
    }

    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => OtpScreen(phoneNumber: widget.phoneNumber),
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
      ),
    );
  }

  Map<String, dynamic> _parsePhone(String fullPhone) {
    for (final country in CountryPicker.countries) {
      if (fullPhone.startsWith(country.dialCode)) {
        return {
          'country': country,
          'phone': fullPhone.substring(country.dialCode.length),
        };
      }
    }
    return {
      'country': CountryPicker.countries.first,
      'phone': fullPhone,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.t('create_account')),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocalization.t('register_subtitle'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: AppLocalization.t('first_name'),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  validator: (value) => _mapNameError(_viewModel.validateName(value ?? '')),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: AppLocalization.t('last_name'),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  validator: (value) => _mapNameError(_viewModel.validateName(value ?? '')),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: _localPhoneNumber,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: AppLocalization.t('phone_number'),
                    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                    prefixIcon: Padding(
                      padding: const EdgeInsetsDirectional.only(start: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${_phoneCountry.dialCode} ${_phoneCountry.flag}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            height: 24,
                            width: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _viewModel.isSubmitting ? null : _createAccount,
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
                      : Text(AppLocalization.t('create_account')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
