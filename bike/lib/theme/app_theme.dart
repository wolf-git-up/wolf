import 'package:flutter/material.dart';

class AppColors {
  // Copper & Warm Premium Theme
  static const background = Color(0xFF151515); // Primary: Dark Background
  static const surface = Color(0xFF222222); // Secondary: Card Surface
  static const card = Color(0xFF222222); // Cards: Warm Dark
  static const orange = Color(0xFFB87333); // Accent: Copper
  static const orangeDim = Color(0xFFD4A373); // Dimmed: Secondary Copper
  static const orangeGlow = Color(0x33B87333); // Copper Glow Effect
  static const white = Color(0xFFFFFFFF); // Accent: Pure White
  static const grey = Color(0xFF000000); // Subtext: Black
  static const greyDark = Color(0xFFFFFFFF); // Borders: White
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
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Color.fromARGB(255, 255, 255, 255),
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
        color: Color.fromARGB(255, 206, 111, 22),
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),
    ),
    dividerColor: AppColors.greyDark,
    iconTheme: const IconThemeData(color: AppColors.orange),
  );
}
