import 'dart:convert';

import 'package:flutter/services.dart';

class LanguageLoader {
  Future<Map<String, String>> load(String languageCode) async {
    final jsonString = await rootBundle.loadString('assets/lang/$languageCode.json');
    final decoded = json.decode(jsonString) as Map<String, dynamic>;
    return decoded.map((key, value) => MapEntry(key, value.toString()));
  }
}
