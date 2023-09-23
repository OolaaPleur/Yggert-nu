import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:yggert_nu/data/repositories/settings_repository.dart';

import '../../constants/constants.dart';
import '../theme.dart';
import '../theme_helpers.dart';

part 'theme_event.dart';
part 'theme_state.dart';

/// Bloc class, main job is defining a theme for an app.
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  /// Constructor for ThemeBloc.
  ThemeBloc()
      : _settingsRepository = GetIt.I<SettingsRepository>(),
        super(LightThemeState()) {
    on<LoadThemeEvent>(_onLoadThemeEvent);
    on<ChangeThemeEvent>(_onChangeThemeEvent);
  }

  final SettingsRepository _settingsRepository;

  /// Checks if dark mode is enabled right now.
  bool get isDarkMode {
    if (state.themeData.brightness == Brightness.dark) {
      return true;
    }
    return false;
  }

  /// Load theme at the start of an app.
  Future<void> _onLoadThemeEvent(
      LoadThemeEvent event,
      Emitter<ThemeState> emit,
      ) async {
    final theme = await _settingsRepository.getStringValue('theme');
    add(ChangeThemeEvent(appTheme: ThemeHelper.toAppTheme(theme)));
  }

  /// Used to set theme in two cases 1) when downloaded user settings
  /// 2)Toggle another theme, button located in settings.
  Future<void> _onChangeThemeEvent(
      ChangeThemeEvent event,
      Emitter<ThemeState> emit,
      ) async {
    if (event.appTheme == AppTheme.dark) {
      emit(DarkThemeState());
      await _settingsRepository.setStringValue('theme', 'AppTheme.dark');
    } else if (event.appTheme == AppTheme.light) {
      emit(LightThemeState());
      await _settingsRepository.setStringValue('theme', 'AppTheme.light');
    } else {
      emit(AutoThemeState());
      await _settingsRepository.setStringValue('theme', 'AppTheme.auto');
    }
  }
}
