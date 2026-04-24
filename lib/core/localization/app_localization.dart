import 'language_loader.dart';

class AppLocalization {
  AppLocalization._();

  static final LanguageLoader _loader = LanguageLoader();
  static Map<String, String> _data = <String, String>{};
  static String _currentLanguageCode = 'ar';

  static String get currentLanguageCode => _currentLanguageCode;

  static Future<void> load(String languageCode) async {
    _data = await _loader.load(languageCode);
    _currentLanguageCode = languageCode;
  }

  static String t(String key) {
    return _data[key] ?? key;
  }
}