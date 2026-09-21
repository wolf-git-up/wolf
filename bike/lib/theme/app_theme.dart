import 'package:flutter/material.dart';

class AppColors {
  static const backgroundLight = Color(0xFFFFFFFF);
  static const surfaceLight = Color(0xFFF5F5F5);
  static const cardLight = Color(0xFFF5F5F5);
  static const backgroundDark = Color(0xFF0F172A);
  static const surfaceDark = Color(0xFF111827);
  static const cardDark = Color(0xFF1F2937);
  static const orange = Color(0xFFE63946);
  static const orangeDim = Color(0xFFFF6B6B);
  static const orangeGlow = Color(0x33E63946);
  static const blue = Color(0xFF0066CC);
  static const blueDim = Color(0xFF3399FF);
  static const blueGlow = Color(0x330066CC);
  static const danger = Color(0xFFFF3B30);
  static const success = Color(0xFF30D158);

  static const background = Color(0xFFFFFFFF);
  static const surface = Color(0xFFF5F5F5);
  static const card = Color(0xFFF5F5F5);
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const grey = Color(0xFF333333);
  static const greyDark = Color(0xFFDDDDDD);

  static bool _useDarkMode = false;

  static void syncTheme(bool useDarkMode) {
    _useDarkMode = useDarkMode;
  }

  static Color get themedBackground =>
      _useDarkMode ? backgroundDark : backgroundLight;
  static Color get themedSurface => _useDarkMode ? surfaceDark : surfaceLight;
  static Color get themedCard => _useDarkMode ? cardDark : cardLight;
  static Color get themedText => _useDarkMode ? white : black;
  static Color get themedGrey => _useDarkMode ? const Color(0xFF6B7280) : grey;
  static Color get themedGreyBorder =>
      _useDarkMode ? const Color(0xFF374151) : greyDark;
}

class AppTheme extends ChangeNotifier {
  AppTheme({bool isDarkMode = false}) : _isDarkMode = isDarkMode {
    AppColors.syncTheme(_isDarkMode);
  }

  bool _isDarkMode;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    AppColors.syncTheme(_isDarkMode);
    notifyListeners();
  }

  void setTheme(bool value) {
    _isDarkMode = value;
    AppColors.syncTheme(_isDarkMode);
    notifyListeners();
  }

  ThemeData get themeData => _isDarkMode ? _darkTheme : _lightTheme;

  static ThemeData get light => _lightTheme;
  static ThemeData get dark => _darkTheme;

  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    primaryColor: AppColors.orange,
    colorScheme: const ColorScheme.light(
      primary: AppColors.orange,
      surface: AppColors.surfaceLight,
      error: AppColors.danger,
    ),
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: AppColors.black,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
      iconTheme: IconThemeData(color: AppColors.orange),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.black,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        color: AppColors.black,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: AppColors.black,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(color: AppColors.black),
      bodyLarge: TextStyle(color: AppColors.black),
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

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    primaryColor: AppColors.orange,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.orange,
      surface: AppColors.surfaceDark,
      error: AppColors.danger,
    ),
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: AppColors.white,
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
      bodyMedium: TextStyle(color: AppColors.greyDark),
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
