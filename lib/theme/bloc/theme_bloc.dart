import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_state.dart';

/// [ThemeBloc] events.
enum ThemeEvent {
  /// Toggle another theme, button located in settings.
  toggle,

  /// Load theme at the start of an app.
  load
}

/// Bloc class, main job is defining a theme for an app.
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  /// Constructor for ThemeBloc.
  ThemeBloc() : super(LightThemeState()) {
    on<ThemeEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      if (event == ThemeEvent.load) {
        final isDark = prefs.getBool('isDark') ?? false;
        if (isDark) {
          emit(DarkThemeState());
        } else {
          emit(LightThemeState());
        }
      } else if (event == ThemeEvent.toggle) {
        if (state is LightThemeState) {
          emit(DarkThemeState());
          await prefs.setBool('isDark', true);
        } else {
          emit(LightThemeState());
          await prefs.setBool('isDark', false);
        }
      }
    });
  }

  /// Toggle another theme, button located in settings.
  void toggleTheme() => add(ThemeEvent.toggle);

  /// Load theme at the start of an app.
  void loadTheme() => add(ThemeEvent.load);
}
