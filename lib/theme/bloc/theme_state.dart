part of 'theme_bloc.dart';

/// Theme state for ThemeBloc.
abstract class ThemeState extends Equatable {
  /// Theme data.
  ThemeData get themeData;
}

/// Auto theme for app.
class AutoThemeState extends ThemeState {
  @override
  ThemeData get themeData {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    if (brightness == Brightness.light) {
      return FlutterAppTheme.light();
    } else {
      return FlutterAppTheme.dark();
    }
  }

  @override
  List<Object> get props => [themeData];
}

/// Light theme for app.
class LightThemeState extends ThemeState {
  @override
  ThemeData get themeData => FlutterAppTheme.light();

  @override
  List<Object> get props => [themeData];
}

/// Dark theme for app.
class DarkThemeState extends ThemeState {
  @override
  ThemeData get themeData => FlutterAppTheme.dark();

  @override
  List<Object> get props => [themeData];
}
