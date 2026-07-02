import 'package:flutter/material.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';

class AppDropdownField<T> extends StatelessWidget {
  final String title;
  final T? value;
  final List<DropdownMenuEntry<T>> items;
  final ValueChanged<T?> onChanged;
  final IconData icon;

  const AppDropdownField({
    super.key,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:  TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 6),

            DropdownMenu<T>(
              width: constraints.maxWidth,
              menuHeight: 250,

              initialSelection: value,

              onSelected: onChanged,

              dropdownMenuEntries: items,

              leadingIcon: Icon(
                icon,
                color: const Color(0xff9CA3AF),
                size: 20,
              ),

              trailingIcon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xff9CA3AF),
              ),

              selectedTrailingIcon: const Icon(
                Icons.keyboard_arrow_up_rounded,
                color: Color(0xff9CA3AF),
              ),

              menuStyle: MenuStyle(
                backgroundColor: const WidgetStatePropertyAll(
                  Color(0xffF5F5F5),
                ),

                elevation: const WidgetStatePropertyAll(5),

                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: const Color(0xffF5F5F5),

                isDense: true,

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

                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}