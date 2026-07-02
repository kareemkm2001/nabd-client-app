import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';

class AppTextField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final IconData icon;
  final int? maxLength;
  final int? minLength;

  const AppTextField({
    super.key,
    required this.title,
    required this.controller,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.maxLength,
    this.minLength,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: controller.text,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: field.hasError
                    ? AppColors.error
                    : AppColors.primary,
              ),
            ),

            const SizedBox(height: 6),

            SizedBox(
              height: 48,
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                maxLines: maxLines,
                readOnly: readOnly,
                onTap: onTap,

                onChanged: (value) {
                  field.didChange(value);
                },

                inputFormatters: [
                  if (keyboardType == TextInputType.number ||
                      keyboardType == TextInputType.phone)
                    FilteringTextInputFormatter.digitsOnly,

                  if (maxLength != null)
                    LengthLimitingTextInputFormatter(maxLength),
                ],

                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffF5F5F5),

                  isDense: true,

                  counterText: "",

                  prefixIcon: Icon(
                    icon,
                    size: 20,
                    color: field.hasError
                        ? AppColors.error
                        : const Color(0xff9CA3AF),
                  ),

                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 45,
                    minHeight: 45,
                  ),

                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),

                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),

                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 18,
              child: field.hasError
                  ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 11,
                  ),
                ),
              )
                  : null,
            ),
          ],
        );
      },
    );
  }
}