import 'package:flutter/material.dart';

/// Class of the app themes data.
abstract class AppThemeData {
  static final ThemeData defaultTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
  );
}
