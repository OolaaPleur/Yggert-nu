import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Cubit, that responses for language change.
class LanguageCubit extends Cubit<Locale> {
  /// Constructor for [LanguageCubit].
  LanguageCubit() : super(const Locale('en')) {
    _loadLocale();
  }
  /// Function, located in Settings, changes language to that, which specified
  /// in [locale].
  void changeLanguage(Locale locale) {
    emit(locale);
    _saveLocale(locale);
  }

  Future<void> _saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    var languageCode = prefs.getString('language_code');
    languageCode ??= PlatformDispatcher.instance.locales.first.languageCode;
    emit(Locale(languageCode, ''));
  }
}
