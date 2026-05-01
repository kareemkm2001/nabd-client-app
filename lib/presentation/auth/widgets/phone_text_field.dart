import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/theme/app_text_styles.dart';
import 'package:nabd_client_app/core/widgets/country_picker_bottom_sheet.dart';

import '../../../../core/localization/app_localization.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/country_picker.dart';

class PhoneTextField extends StatefulWidget {
  final String? titleKey;
  final String? titleText;
  final String? hintKey;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final bool enabled;
  final bool readOnly;
  final String? initialValue;
  final Country? selectedCountry;
  final VoidCallback? onCountryTap;
  final ValueChanged<Country>? onCountryChanged;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final double margin;
  final List<TextInputFormatter>? inputFormatters;
  final bool enableCountryPrefix;
  final String? errorText;

  const PhoneTextField({
    super.key,
    this.titleKey,
    this.titleText,
    this.hintKey,
    this.controller,
    this.validator,
    this.autovalidateMode,
    this.enabled = true,
    this.readOnly = false,
    this.initialValue,
    this.selectedCountry,
    this.onCountryTap,
    this.onCountryChanged,
    this.onChanged,
    this.suffixIcon,
    this.margin = 16,
    this.inputFormatters,
    this.enableCountryPrefix = true,
    this.errorText,
  });

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChanged);
    _selectedCountry = widget.selectedCountry;
  }

  @override
  void didUpdateWidget(covariant PhoneTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCountry != oldWidget.selectedCountry) {
      _selectedCountry = widget.selectedCountry;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  Future<void> _handleCountryTap() async {
    if (widget.onCountryTap != null) {
      widget.onCountryTap!.call();
      return;
    }
    final currentCountry = _selectedCountry ?? CountryPicker.countries.first;
    final selected = await openCountryPicker(
      context,
      selectedCountry: currentCountry,
    );
    if (selected == null || !mounted) return;
    setState(() {
      _selectedCountry = selected;
    });
    widget.onCountryChanged?.call(selected);
  }

  Widget? _buildPrefix(BuildContext context) {
    if (!widget.enableCountryPrefix || _selectedCountry == null) {
      return null;
    }

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 12),
      child: GestureDetector(
        onTap: _handleCountryTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${_selectedCountry!.dialCode} ${_selectedCountry!.flag}',
              style: AppTextStyles.mediumBlack,
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
    );
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
          if ((widget.titleText != null && widget.titleText!.isNotEmpty) ||
              (widget.titleKey != null && widget.titleKey!.isNotEmpty))
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: _isFocused
                  ? AppTextStyles.smallPrimary
                  : AppTextStyles.mediumBlack,
              child: widget.titleText != null && widget.titleText!.isNotEmpty
                  ? Text(widget.titleText!)
                  : AppText(
                      jsonKey: widget.titleKey!,
                    ),
            ),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: TextFormField(
              focusNode: _focusNode,
              controller: widget.controller,
              initialValue: widget.controller == null ? widget.initialValue : null,
              validator: widget.validator,
              keyboardType: TextInputType.phone,
              autovalidateMode: widget.autovalidateMode,
              inputFormatters: widget.inputFormatters ??
                  <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
              enabled: widget.enabled,
              readOnly: widget.readOnly,
              onChanged: widget.onChanged,
              style: AppTextStyles.mediumBlack,
              decoration: InputDecoration(
                hintText: AppLocalization.t(widget.hintKey ?? ''),
                errorText: widget.errorText,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                prefixIcon: _buildPrefix(context),
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