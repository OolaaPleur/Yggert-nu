part of 'theme_bloc.dart';

/// [ThemeBloc] events.
abstract class ThemeEvent {}

/// Toggle another theme, button located in settings.
class ChangeThemeEvent extends ThemeEvent {
  /// Constructor for [ChangeThemeEvent].
  ChangeThemeEvent({required this.appTheme});

  /// AppTheme, needed to determine which theme to enable.
  final AppTheme appTheme;
}

/// Load theme at the start of an app.
class LoadThemeEvent extends ThemeEvent {}
