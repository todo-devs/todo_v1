import 'package:flutter/material.dart';
import 'package:todo/themes/dark_theme.dart';
import 'package:todo/themes/light_theme.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = themeLight;
  static final ThemeData darkTheme = themeDark;
}