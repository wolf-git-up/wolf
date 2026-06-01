import 'package:flutter/material.dart';

class AppColors {
  // Ducati-Inspired Premium Theme
  static const background = Color(0xFF0D0D0D); // Primary: Deep Black
  static const surface = Color(0xFF1A1A1A); // Secondary: Dark Grey
  static const card = Color(0xFF1A1A1A); // Cards: Dark Grey
  static const orange = Color(0xFFE10600); // Accent: Ducati Red
  static const orangeDim = Color(0xFFB00000); // Dimmed Red
  static const orangeGlow = Color(0x33E10600); // Red Glow Effect
  static const white = Color(0xFFFFFFFF); // Accent: Pure White
  static const grey = Color(0xFF888888);
  static const greyDark = Color(0xFF333333);
  static const danger = Color(0xFFFF3B30);
  static const success = Color(0xFF30D158);
}

class AppTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.orange,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.orange,
      surface: AppColors.surface,
      error: AppColors.danger,
    ),
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: AppColors.orange,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
      iconTheme: IconThemeData(color: AppColors.orange),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(color: AppColors.white),
      bodyLarge: TextStyle(color: AppColors.white),
      bodyMedium: TextStyle(color: AppColors.grey),
      labelLarge: TextStyle(
        color: AppColors.orange,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),
    ),
    dividerColor: AppColors.greyDark,
    iconTheme: const IconThemeData(color: AppColors.orange),
  );
}
