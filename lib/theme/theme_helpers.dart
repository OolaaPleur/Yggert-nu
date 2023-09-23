import '../constants/constants.dart';

/// Helper widget for Theme.
class ThemeHelper {
  /// Convert String to AppTheme enum.
  static AppTheme toAppTheme(String theme) {
    switch (theme) {
      case 'AppTheme.light':
        return AppTheme.light;
      case 'AppTheme.dark':
        return AppTheme.dark;
      case 'AppTheme.auto':
        return AppTheme.auto;
      default:
        throw ArgumentError('Invalid string value for AppTheme enum');
    }
  }
}
