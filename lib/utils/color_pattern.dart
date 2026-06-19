import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFE94E1B), // tomato
    surfaceTint: const Color(0xFFFFF8F2), // cream
    surface: const Color(0xFFFAE3D9), // cocoa
    brightness: Brightness.light, // Ensure brightness matches
  ),
  useMaterial3: true,
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF8B1E3F), // wine
    surfaceTint: const Color(0xFF1E1E1E),
    surface: const Color(0xFF2A2A2A),
    brightness: Brightness.dark, // Ensure brightness matches
  ),
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
