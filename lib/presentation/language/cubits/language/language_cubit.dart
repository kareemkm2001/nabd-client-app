import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localization.dart';
import '../../../../core/services/language_service.dart';
import 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(const LanguageState(locale: Locale('ar')));

  final LanguageService _service = LanguageService();

  Future<void> init() async {
    final savedLanguageCode = await _service.getLanguage();
    final languageCode = savedLanguageCode ?? 'ar';
    await AppLocalization.load(languageCode);
    emit(LanguageState(locale: Locale(languageCode)));
  }

  Future<void> changeLanguage(String languageCode) async {
    await AppLocalization.load(languageCode);
    await _service.saveLanguage(languageCode);
    emit(LanguageState(locale: Locale(languageCode)));
  }

  String t(String key) {
    return AppLocalization.t(key);
  }
}

