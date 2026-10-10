import 'package:flutter/material.dart';

class AppTheme {
  static const ink = Color(0xFF172A32);
  static const muted = Color(0xFF5D7176);
  static const forest = Color(0xFF176C61);
  static const canvas = Color(0xFFF4F7F5);
  static const line = Color(0xFFDCE6E2);

  static ThemeData get light {
    final colors = ColorScheme.fromSeed(
      seedColor: forest,
      brightness: Brightness.light,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: canvas,
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: ink,
          fontSize: 32,
          height: 1.15,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: ink,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(color: muted, fontSize: 16, height: 1.55),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: canvas,
        foregroundColor: ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: forest,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          minimumSize: const Size(48, 52),
          side: const BorderSide(color: line),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: line),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      dividerColor: line,
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
