import 'package:flutter/material.dart';

/// Custom theme configuration for elderly-friendly interface
class GrandmaThemeConfig {
  // Warm, comfortable color palette
  static const Color warmOrange = Color(0xFFE67E22);
  static const Color softCream = Color(0xFFFFF8DC);
  static const Color gentleGreen = Color(0xFF27AE60);
  static const Color comfortBlue = Color(0xFF3498DB);
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textLight = Color(0xFF7F8C8D);

  static ThemeData buildAccessibleTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: warmOrange,
      scaffoldBackgroundColor: softCream,
      
      // Extra large fonts for readability
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w900,
          color: textDark,
          letterSpacing: 0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: textDark,
        ),
        titleLarge: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: textDark,
        ),
        bodyLarge: TextStyle(
          fontSize: 22,
          height: 1.6,
          color: textDark,
        ),
        bodyMedium: TextStyle(
          fontSize: 20,
          height: 1.5,
          color: textDark,
        ),
      ),

      // Large, easy-to-tap buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(140, 60),
          backgroundColor: warmOrange,
          foregroundColor: Colors.white,
          textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 6,
        ),
      ),

      // Large input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: warmOrange, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: textLight, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: warmOrange, width: 3),
        ),
        labelStyle: TextStyle(fontSize: 20, color: textDark),
        hintStyle: TextStyle(fontSize: 20, color: textLight),
      ),

      cardTheme: CardTheme(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        margin: EdgeInsets.all(12),
      ),

      iconTheme: IconThemeData(
        size: 32,
        color: warmOrange,
      ),
    );
  }
}

/// Accessible color helpers
class AccessibleColors {
  static Color getContrastingText(Color background) {
    final luminance = background.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }

  static Color getMealCategoryColor(int categoryIndex) {
    final colors = [
      Color(0xFFFFD93D), // Morning yellow
      Color(0xFFFF6B6B), // Lunch red
      Color(0xFF95E1D3), // Snack mint
      Color(0xFF6C5CE7), // Evening purple
    ];
    return colors[categoryIndex % colors.length];
  }
}
