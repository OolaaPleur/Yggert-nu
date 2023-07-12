import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobility_app/data/repositories/settings_repository.dart';

import 'theme_event.dart';
import 'theme_state.dart';

/// Bloc class, main job is defining a theme for an app.
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  /// Constructor for ThemeBloc.
  ThemeBloc()
      : _settingsRepository = GetIt.I<SettingsRepository>(),
        super(LightThemeState()) {
    on<LoadThemeEvent>(_onLoadThemeEvent);
    on<ToggleThemeEvent>(_onToggleThemeEvent);
    on<ToggleDownloadedThemeEvent>(_onToggleDownloadedThemeEvent);
  }

  final SettingsRepository _settingsRepository;

  /// Checks if dark mode is enabled right now.
  bool get isDarkModeEnabled => state is DarkThemeState;

  /// Load theme at the start of an app.
  Future<void> _onLoadThemeEvent(
    LoadThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final isDark = await _settingsRepository.getBoolValue('isDark');
    add(ToggleDownloadedThemeEvent(isDark: isDark));
  }

  /// Toggle another theme, button located in settings.
  Future<void> _onToggleThemeEvent(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    if (state is LightThemeState) {
      emit(DarkThemeState());
      await _settingsRepository.setBoolValue('isDark', value: true);
    } else {
      emit(LightThemeState());
      await _settingsRepository.setBoolValue('isDark', value: false);
    }
  }

  /// Used to set theme in two cases 1) when downloaded user settings
  /// 2) when theme set by user in [LoadThemeEvent].
  Future<void> _onToggleDownloadedThemeEvent(
    ToggleDownloadedThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    if (event.isDark) {
      emit(DarkThemeState());
    } else {
      emit(LightThemeState());
    }
  }
}
