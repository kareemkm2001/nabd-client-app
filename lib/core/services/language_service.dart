import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _key = "lang";

  Future<void> saveLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, code);
  }

  Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
}