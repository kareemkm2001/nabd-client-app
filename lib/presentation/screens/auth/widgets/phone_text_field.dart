import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nabd_client_app/core/theme/app_text_styles.dart';
import 'package:nabd_client_app/core/widgets/app_text.dart';

import '../../../../core/localization/app_localization.dart';
import '../../../widgets/country_picker.dart';

class PhoneTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final Country selectedCountry;
  final VoidCallback onCountryTap;
  final ValueChanged<String>? onChanged;
  final String? hint;

  const PhoneTextField({
    super.key,
    required this.controller,
    required this.selectedCountry,
    required this.onCountryTap,
    this.errorText,
    this.onChanged,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        labelText: AppLocalization.t('phone_number'),
        hintText: hint ?? '5XXXXXXXX',
        errorText: errorText,

        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        prefixIcon: Padding(
          padding: const EdgeInsetsDirectional.only(start: 12),
          child: GestureDetector(
            onTap: onCountryTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  jsonKey:'${selectedCountry.dialCode} ${selectedCountry.flag}',
                  textStyle: AppTextStyles.mediumBlack,
                ),
                const SizedBox(width: 6),
                const Icon(Icons.arrow_drop_down, size: 18),
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
        ),

        filled: true,
        fillColor: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.35),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onChanged: onChanged,
    );
  }
}