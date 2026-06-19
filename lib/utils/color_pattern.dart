import 'package:flutter/material.dart';

ColorScheme lightColorScheme = const ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFE94E1B), // tomato
  onPrimary: Colors.white,
  secondary: Color(0xFFFAE3D9), // cocoa
  onSecondary: Colors.black,
  error: Colors.red,
  onError: Colors.white,
  surface: Color(0xFFFAE3D9), // cocoa
  onSurface: Colors.black,
);

ColorScheme darkColorScheme = const ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFE94E1B), // tomato
  onPrimary: Colors.white,
  secondary: Color(0xFFFAE3D9), // cocoa
  onSecondary: Colors.black,
  error: Colors.red,
  onError: Colors.white,
  surface: Color(0xFF2A2A2A), // dark surface
  onSurface: Colors.white,
);

final lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: lightColorScheme,
  scaffoldBackgroundColor: lightColorScheme.surface,
  useMaterial3: true,
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
  scaffoldBackgroundColor: darkColorScheme.surface,
  useMaterial3: true,
);

Color getCategoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'légume':
      return Colors.green;
    case 'viande':
      return Colors.red;
    case 'épice':
      return Colors.orange;
    case 'huile':
      return Colors.amber;
    default:
      return Colors.blue;
  }
}
