import 'package:flutter/material.dart';

class Country {
  final String name;
  final String dialCode;
  final String flag;

  const Country({
    required this.name,
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
    Country(name: 'Saudi Arabia', dialCode: '+966', flag: '🇸🇦'),
    Country(name: 'Egypt', dialCode: '+20', flag: '🇪🇬'),
    Country(name: 'United Arab Emirates', dialCode: '+971', flag: '🇦🇪'),
    Country(name: 'Kuwait', dialCode: '+965', flag: '🇰🇼'),
    Country(name: 'Qatar', dialCode: '+974', flag: '🇶🇦'),
    Country(name: 'United States', dialCode: '+1', flag: '🇺🇸'),
    Country(name: 'United Kingdom', dialCode: '+44', flag: '🇬🇧'),
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Country>(
      value: selectedCountry,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
      items: countries
          .map(
            (country) => DropdownMenuItem<Country>(
              value: country,
              child: Text('${country.flag} ${country.name} (${country.dialCode})'),
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
