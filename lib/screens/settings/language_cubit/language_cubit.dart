import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../data/repositories/settings_repository.dart';

/// Cubit, that responses for language change.
class LanguageCubit extends Cubit<Locale> {

  /// Constructor for [LanguageCubit].
  LanguageCubit()
      : _settingsRepository = GetIt.I<SettingsRepository>(),
        super(const Locale('en')) {
    _loadLocale();
  }
  final SettingsRepository _settingsRepository;

  /// Function, located in Settings, changes language to that, which specified
  /// in [locale].
  Future<void> changeLanguage(Locale locale) async {
    emit(locale);
    await _settingsRepository.setStringValue('language_code', locale.languageCode);
  }

  Future<void> _loadLocale() async {
    final languageCode = await _settingsRepository.getStringValue('language_code');
    emit(Locale(languageCode));
  }
}
