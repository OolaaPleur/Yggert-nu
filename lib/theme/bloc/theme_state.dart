import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

/// Theme state for ThemeBloc.
abstract class ThemeState extends Equatable {
  /// Theme data.
  ThemeData get themeData;
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
