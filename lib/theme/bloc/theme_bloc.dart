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
    on<ThemeEvent>(_onThemeEvent);
  }

  Future<void> _onThemeEvent(ThemeEvent event, Emitter<ThemeState> emit) async {
    if (event is LoadThemeEvent) {
      final isDark = await _settingsRepository.getBoolValue('isDark');
      if (isDark) {
        emit(DarkThemeState());
      } else {
        emit(LightThemeState());
      }
    } else if (event is ToggleThemeEvent) {
      if (state is LightThemeState) {
        emit(DarkThemeState());
        await _settingsRepository.setBoolValue('isDark', value: true);
      } else {
        emit(LightThemeState());
        await _settingsRepository.setBoolValue('isDark', value: false);
      }
    } else if (event is ToggleDownloadedThemeEvent) {
      if (event.isDark) {
        emit(DarkThemeState());
      } else {
        emit(LightThemeState());
      }
    }
  }

  final SettingsRepository _settingsRepository;

  /// Load theme at the start of an app.
  void loadTheme() => add(LoadThemeEvent());
  /// Toggle another theme, button located in settings.
  void toggleDownloadedTheme({required bool isDark}) => add(ToggleDownloadedThemeEvent(isDark: isDark));

  /// Checks if dark mode is enabled right now.
  bool get isDarkModeEnabled => state is DarkThemeState;
}
