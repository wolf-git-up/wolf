import 'package:flutter/material.dart';

class AppColors {
  // White Background, Black Text, Red & Blue Graphics Theme (BMW Colors)
  static const background = Color(0xFFFFFFFF); // Primary: White Background
  static const surface = Color(0xFFF5F5F5); // Secondary: Light Gray Surface
  static const card = Color(0xFFF5F5F5); // Cards: Light Gray
  static const orange = Color(0xFFE63946); // Accent: Red (BMW Red)
  static const orangeDim = Color(0xFFFF6B6B); // Dimmed: Light Red
  static const orangeGlow = Color(0x33E63946); // Red Glow Effect
  static const blue = Color(0xFF0066CC); // BMW Blue
  static const blueDim = Color(0xFF3399FF); // Light Blue
  static const blueGlow = Color(0x330066CC); // Blue Glow Effect
  static const white = Color(0xFF000000); // Accent: Black Text
  static const grey = Color(0xFF333333); // Subtext: Dark Gray
  static const greyDark = Color(0xFFDDDDDD); // Borders: Light Gray
  static const danger = Color(0xFFFF3B30);
  static const success = Color(0xFF30D158);
}

class AppTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.orange,
    colorScheme: const ColorScheme.light(
      primary: AppColors.orange,
      surface: AppColors.surface,
      error: AppColors.danger,
    ),
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Color.fromARGB(255, 255, 252, 252),
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
