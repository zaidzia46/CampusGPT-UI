import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF7C3AED); // Deep Purple
  static const Color accentColor = Color(0xFF06B6D4); // Cyan
  static const Color backgroundColor = Color(0xFF0F172A); // Very Dark Blue
  static const Color surfaceColor = Color(0xFF1E293B); // Dark Slate
  static const Color textPrimary = Color(0xFFFFFFFF); // White
  static const Color textSecondary = Color(0xFFCBD5E1); // Light Gray
  static const Color borderColor = Color(0xFF334155); // Medium Gray

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
        background: backgroundColor,
        error: const Color(0xFFEF4444),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          color: textPrimary,
          fontFamily: 'p-b-font',
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          fontFamily: 'p-b-font',
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          color: textPrimary,
          fontFamily: 'p-m-font',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textPrimary,
          fontFamily: 'i-font',
          fontWeight: FontWeight.w500,
        ),

        bodyMedium: TextStyle(
          fontSize: 14,
          color: textSecondary,
          fontFamily: 'i-font',
          fontWeight: FontWeight.w400,
        ),

        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          fontFamily: 'i-font',
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          fontFamily: 'p-m-font',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'p-m-font',
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentColor, width: 2),
        ),
        hintStyle: TextStyle(
          color: textSecondary,
          fontSize: 14,
          fontFamily: 'i-s-font',
        ),
      ),
    );
  }
}
