import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../theme/theme_colors.dart';

/// Extension on BuildContext, to make shorter call.
extension BuildContextExt on BuildContext {
  /// Call to AppLocalizations, looks nicer than default.
  AppLocalizations get localizations => AppLocalizations.of(this)!;
  /// Shorter call to ThemeColors extension.
  ThemeColors get color => Theme.of(this).extension<ThemeColors>()!;
}
