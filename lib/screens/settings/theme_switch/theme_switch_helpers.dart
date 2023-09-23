import '../../../constants/constants.dart';
import '../../../theme/bloc/theme_bloc.dart';

/// Converts state object in enum.
AppTheme convertStateInEnum (ThemeState state) {
  if (state is LightThemeState) {
    return AppTheme.light;
  }
  if (state is DarkThemeState) {
    return AppTheme.dark;
  }
  return AppTheme.auto;
}
