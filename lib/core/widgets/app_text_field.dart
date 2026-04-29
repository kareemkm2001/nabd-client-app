import 'package:flutter/material.dart';
import 'package:nabd_client_app/core/localization/app_localization.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/widgets/app_text.dart';
import '../theme/app_text_styles.dart';

class AppTextField extends StatefulWidget {
  final String? titleKey;
  final String? hintKey;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final double margin;

  const AppTextField({
    super.key,
    this.titleKey,
    this.hintKey,
    this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.margin = 16,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  bool isFocused = false;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: widget.margin,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          if (widget.titleKey != null && widget.titleKey!.isNotEmpty)
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: isFocused
                  ? AppTextStyles.smallPrimary
                  : AppTextStyles.mediumBlack,
              child: AppText(
                jsonKey: AppLocalization.t(widget.titleKey!)
              ),
            ),

          const SizedBox(height: 6),

          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: TextFormField(
              focusNode: _focusNode,
              controller: widget.controller,
              validator: widget.validator,
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText,
              onChanged: widget.onChanged,
              style: AppTextStyles.mediumBlack,

              decoration: InputDecoration(
                hintText: AppLocalization.t(widget.hintKey ?? ""),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),

                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.suffixIcon,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.secondary,
                    width: 1,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),

                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.error,
                    width: 1,
                  ),
                ),

                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.error,
                    width: 1.5,
                  ),
                ),

                errorStyle: const TextStyle(
                  fontSize: 12,
                  color: AppColors.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}