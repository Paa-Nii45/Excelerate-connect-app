import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryPurple = Color(0xFF667EEA);
  static const Color secondaryPurple = Color(0xFF764BA2);
  static const Color accentGold = Color(0xFFFFD700);

  // Neutral Colors
  static const Color textDark = Color(0xFF333333);
  static const Color textMedium = Color(0xFF666666);
  static const Color textLight = Color(0xFF999999);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color borderColor = Color(0xFFE0E0E0);

  // Category Colors
  static const Color internshipBg = Color(0xFFE3F2FD);
  static const Color internshipText = Color(0xFF1976D2);
  static const Color eventBg = Color(0xFFFFF3E0);
  static const Color eventText = Color(0xFFF57C00);
  static const Color competitionBg = Color(0xFFF3E5F5);
  static const Color competitionText = Color(0xFF8E24AA);
  static const Color masterclassBg = Color(0xFFE8F5E9);
  static const Color masterclassText = Color(0xFF2E7D32);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        primary: primaryPurple,
        secondary: secondaryPurple,
      ),
      scaffoldBackgroundColor: Colors.white,

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: textDark,
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textDark,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textMedium,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryPurple, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Gradient for cards and featured content
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, secondaryPurple],
  );

  // Method to get category colors
  static Map<String, Color> getCategoryColors(String category) {
    switch (category.toLowerCase()) {
      case 'internship':
        return {'background': internshipBg, 'text': internshipText};
      case 'event':
        return {'background': eventBg, 'text': eventText};
      case 'competition':
        return {'background': competitionBg, 'text': competitionText};
      case 'masterclass':
        return {'background': masterclassBg, 'text': masterclassText};
      default:
        return {'background': internshipBg, 'text': internshipText};
    }
  }
}