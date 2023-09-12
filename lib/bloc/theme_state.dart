import 'package:flutter/material.dart';

enum AppTheme { red, blue, green, purple, dark, light}

Color getThemeColor(AppTheme theme) {
  switch (theme) {
    case AppTheme.red:
      return Colors.red;
    case AppTheme.blue:
      return Colors.blue;
    case AppTheme.green:
      return Colors.green;
    case AppTheme.dark:
      return Colors.black;
    default:
      return Colors.purple;
  }
}
