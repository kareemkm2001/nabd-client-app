import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';

class AppCountryCodeField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const AppCountryCodeField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "كود الدولة",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CountryCodePicker(
              onChanged: (country) {
                controller.text = country.dialCode?.replaceAll("+", "") ?? "";
                onChanged?.call(controller.text);
              },
              initialSelection: 'SA',
              favorite: const [
                'SA',
                'EG',
                'AE',
                'KW',
                'QA',
                'BH',
                'OM',
              ],
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              alignLeft: true,
              padding: EdgeInsets.zero,
              textStyle: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              dialogBackgroundColor: AppColors.background,
              headerText: "اختار دولتك",
              searchDecoration: InputDecoration(
                hintText: "ابحث عن دولة",
                filled: true,
                fillColor: const Color(0xffF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 18,
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "",
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 11,
                ),
              ),
            )

          ),
        ],
      ),
    );
  }
}