import 'package:flutter/material.dart';
import 'package:nabd_client_app/core/localization/app_localization.dart';

class Country {
  final String nameKey;
  final String dialCode;
  final String flag;

  const Country({
    required this.nameKey,
    required this.dialCode,
    required this.flag,
  });
}

class CountryPicker extends StatelessWidget {
  final Country selectedCountry;
  final ValueChanged<Country> onChanged;

  const CountryPicker({
    super.key,
    required this.selectedCountry,
    required this.onChanged,
  });

  static const List<Country> countries = [
    Country(nameKey: 'country_saudi_arabia', dialCode: '+966', flag: '🇸🇦'),
    Country(nameKey: 'country_egypt', dialCode: '+20', flag: '🇪🇬'),
    Country(nameKey: 'country_united_arab_emirates', dialCode: '+971', flag: '🇦🇪'),
    Country(nameKey: 'country_kuwait', dialCode: '+965', flag: '🇰🇼'),
    Country(nameKey: 'country_qatar', dialCode: '+974', flag: '🇶🇦'),
    Country(nameKey: 'country_united_states', dialCode: '+1', flag: '🇺🇸'),
    Country(nameKey: 'country_united_kingdom', dialCode: '+44', flag: '🇬🇧'),
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Country>(
      value: selectedCountry,
      borderRadius: BorderRadius.circular(16),
      decoration: InputDecoration(
        labelText: AppLocalization.t('country'),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      items: countries
          .map(
            (country) => DropdownMenuItem<Country>(
              value: country,
              child: Text(
                '${country.flag} ${AppLocalization.t(country.nameKey)} (${country.dialCode})',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}
