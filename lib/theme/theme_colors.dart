import 'package:flutter/material.dart';

/// Class, act as extension to theme.
class ThemeColors extends ThemeExtension<ThemeColors> {
  /// Constructor for [ThemeColors].
  const ThemeColors({
    required this.dotsContainerBottomColor,
  });

  /// Dark theme.
  ThemeColors.dark() : dotsContainerBottomColor = const Color(0xFF141514);

  /// Light theme.
  ThemeColors.light() : dotsContainerBottomColor = Colors.red[200]!;

  /// Color for dots container in intro.
  final Color dotsContainerBottomColor;

  @override
  ThemeExtension<ThemeColors> copyWith({
    Color? appContainerBackground,
  }) {
    return ThemeColors(
      dotsContainerBottomColor: appContainerBackground ?? dotsContainerBottomColor,
    );
  }

  @override
  ThemeExtension<ThemeColors> lerp(
    ThemeExtension<ThemeColors>? other,
    double t,
  ) {
    if (other is! ThemeColors) {
      return this;
    }

    return ThemeColors(
      dotsContainerBottomColor:
          Color.lerp(dotsContainerBottomColor, other.dotsContainerBottomColor, t)!,
    );
  }
}
