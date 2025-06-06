import 'package:flutter/material.dart';

class AppTheme {
  static const _primaryColor = Color(0xFF6366F1); // Indigo
  static const _secondaryColor = Color(0xFF06B6D4); // Cyan
  static const _errorColor = Color(0xFFEF4444); // Red
  static const _successColor = Color(0xFF10B981); // Green
  static const _warningColor = Color(0xFFF59E0B); // Amber

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Poppins',
      colorScheme: const ColorScheme.light(
        primary: _primaryColor,
        secondary: _secondaryColor,
        error: _errorColor,
        surface: Color(0xFFFAFAFA),
        surfaceContainerHighest: Color(0xFFF5F5F5),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
        onSurface: Color(0xFF1F2937),
        onSurfaceVariant: Color(0xFF6B7280),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF1F2937),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
          color: Color(0xFF1F2937),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400),
        displayMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400),
        displaySmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400),
        headlineLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
        titleSmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400),
        bodySmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400),
        labelLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
        labelMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
        labelSmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Poppins',
      colorScheme: const ColorScheme.dark(
        primary: _primaryColor,
        secondary: _secondaryColor,
        error: _errorColor,
        surface: Color(0xFF0F172A),
        surfaceContainerHighest: Color(0xFF334155),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
        onSurface: Color(0xFFF1F5F9),
        onSurfaceVariant: Color(0xFF94A3B8),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFFF1F5F9),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
          color: Color(0xFFF1F5F9),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: const Color(0xFF1E293B),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF334155),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF475569)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF475569)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400),
        displayMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400),
        displaySmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400),
        headlineLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
        titleSmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400),
        bodySmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400),
        labelLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
        labelMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
        labelSmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
      ),
    );
  }

  // Custom colors for specific use cases
  static const Color successColor = _successColor;
  static const Color warningColor = _warningColor;
  static const Color infoColor = _secondaryColor;

  // Subject colors for customization
  static const List<Color> subjectColors = [
    Color(0xFF6366F1), // Indigo
    Color(0xFF06B6D4), // Cyan
    Color(0xFF10B981), // Emerald
    Color(0xFFF59E0B), // Amber
    Color(0xFFEF4444), // Red
    Color(0xFF8B5CF6), // Violet
    Color(0xFFEC4899), // Pink
    Color(0xFF84CC16), // Lime
    Color(0xFFF97316), // Orange
    Color(0xFF14B8A6), // Teal
  ];

  // Spacing constants
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Border radius constants
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
} 