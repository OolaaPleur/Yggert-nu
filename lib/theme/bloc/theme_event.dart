import 'theme_bloc.dart';
/// [ThemeBloc] events.
abstract class ThemeEvent {}
/// Toggle another theme, button located in settings.
class ToggleThemeEvent extends ThemeEvent {}
/// Load theme at the start of an app.
class LoadThemeEvent extends ThemeEvent {}
/// Toggle theme from downloaded data.
class ToggleDownloadedThemeEvent extends ThemeEvent {
/// Constructor for [ToggleDownloadedThemeEvent].
  ToggleDownloadedThemeEvent({required this.isDark});
  /// Bool property, specifies which theme to toggle, dark or light.
  final bool isDark;
}
