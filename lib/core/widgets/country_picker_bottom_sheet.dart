import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nabd_client_app/core/localization/app_localization.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/theme/app_text_styles.dart';
import 'package:nabd_client_app/core/widgets/app_text.dart';
import 'package:nabd_client_app/core/widgets/country_picker.dart';

Future<Country?> openCountryPicker(
  BuildContext context, {
  required Country selectedCountry,
  List<Country>? countries,
}) {
  return showModalBottomSheet<Country>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    barrierColor: Colors.black.withValues(alpha: 0.28),
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (context) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: CountryPickerBottomSheet(
            countries: countries ?? CountryPicker.countries,
            selectedCountry: selectedCountry,
          ),
        ),
      );
    },
  );
}

class CountryPickerBottomSheet extends StatefulWidget {
  final List<Country> countries;
  final Country selectedCountry;

  const CountryPickerBottomSheet({
    super.key,
    required this.countries,
    required this.selectedCountry,
  });

  @override
  State<CountryPickerBottomSheet> createState() => _CountryPickerBottomSheetState();
}

class _CountryPickerBottomSheetState extends State<CountryPickerBottomSheet>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late final AnimationController _entryController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Curves.easeOutCubic,
      ),
    );
    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final query = _searchQuery.trim().toLowerCase();
    final filtered = widget.countries.where((country) {
      if (query.isEmpty) return true;
      final localizedCountryName = AppLocalization.t(country.nameKey).toLowerCase();
      return localizedCountryName.contains(query) ||
          country.dialCode.toLowerCase().contains(query);
    }).toList(growable: false);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            top: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom + 12,
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.72,
            minChildSize: 0.5,
            maxChildSize: 0.80,
            expand: false,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.35),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20,),
                    AppText(
                      jsonKey: AppLocalization.t('country_code'),
                      textStyle: AppTextStyles.largeBlack,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: AppLocalization.t('search'),
                        prefixIcon: const Icon(Icons.search_rounded),
                        filled: true,
                        fillColor: AppColors.secondary.withValues(alpha: 0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.separated(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 6),
                        itemBuilder: (context, index) {
                          final country = filtered[index];
                          final isSelected = country == widget.selectedCountry;
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () => Navigator.of(context).pop(country),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                curve: Curves.easeOutCubic,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: isSelected
                                      ? AppColors.secondary.withValues(alpha: 0.14)
                                      : colorScheme.surfaceContainerLowest,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.surface,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(country.flag, style: textTheme.titleMedium),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        AppLocalization.t(country.nameKey),
                                        style: textTheme.bodyLarge?.copyWith(
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      country.dialCode,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: isSelected
                                            ? colorScheme.primary
                                            : colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (isSelected) ...[
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.check_circle_rounded,
                                        size: 20,
                                        color: AppColors.primary,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
