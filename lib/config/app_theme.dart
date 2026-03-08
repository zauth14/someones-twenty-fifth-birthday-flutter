import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Color palette and theme configuration for the app
class AppTheme {
  // Birthday Mode Colors (Purple & Orange)
  static const Color birthdayPurplePrimary = Color(0xFF8B5CF6); // Violet
  static const Color birthdayPurpleLight = Color(0xFFA78BFA); // Lavender
  static const Color birthdayPurpleDark = Color(0xFF7C3AED); // Deep Violet

  static const Color birthdayOrangePrimary = Color(0xFFF97316); // Orange
  static const Color birthdayOrangeLight = Color(0xFFFB923C); // Peach
  static const Color birthdayOrangeDark = Color(0xFFEA580C); // Deep Orange

  static const Color birthdayBackground = Color(0xFF1F1B29); // Dark Purple-Gray
  static const Color birthdayCardBg = Color(0xFF2D2438); // Slightly lighter
  static const Color birthdayTextPrimary = Color(0xFFFFFFFF); // White
  static const Color birthdayTextAccent = Color(0xFFFCD34D); // Warm Yellow

  // Normal Mode Colors (Lighter Purple & Orange)
  static const Color normalPurplePrimary = Color(0xFFC084FC); // Light Purple
  static const Color normalPurpleLight = Color(0xFFE9D5FF); // Very Light Purple
  static const Color normalPurpleDark = Color(0xFFA855F7); // Medium Purple
  static const Color normalOrangePrimary = Color(0xFFFFA500); // Light Orange
  static const Color normalOrangeLight = Color(0xFFFFD699); // Very Light Orange
  static const Color normalOrangeDark = Color(0xFFFF8C00); // Medium Orange
  static const Color normalBackground = Color(0xFFFAF5FF); // Very Light Purple-tinted
  static const Color normalCardBg = Color(0xFFFFFFFF); // White
  static const Color normalTextPrimary = Color(0xFF2D1B4E); // Dark Purple-ish
  static const Color normalAccent = Color(0xFFFFA500); // Orange
  // Kept for backwards compatibility
  static const Color normalBluePrimary = Color(0xFFC084FC);
  static const Color normalGreenPrimary = Color(0xFFA855F7);

  // Common Colors
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFFBBF24);

  /// Birthday Mode gradient (Purple to Orange)
  static const LinearGradient birthdayGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [birthdayPurplePrimary, birthdayOrangePrimary],
  );

  /// Birthday Mode card gradient
  static const LinearGradient birthdayCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [birthdayPurpleDark, birthdayOrangeDark],
  );

  /// Normal Mode gradient
  static const LinearGradient normalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [normalPurplePrimary, normalOrangePrimary],
  );

  /// Get Birthday Mode theme
  static ThemeData getBirthdayTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: birthdayPurplePrimary,
      scaffoldBackgroundColor: birthdayBackground,
      colorScheme: const ColorScheme.dark(
        primary: birthdayPurplePrimary,
        secondary: birthdayOrangePrimary,
        surface: birthdayCardBg,
        error: error,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: birthdayTextPrimary,
        displayColor: birthdayTextPrimary,
      ),
      cardTheme: CardThemeData(
        color: birthdayCardBg,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: birthdayOrangePrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: birthdayCardBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: birthdayPurpleLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: birthdayPurpleLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: birthdayOrangePrimary, width: 2),
        ),
      ),
    );
  }

  /// Get Normal Mode theme
  static ThemeData getNormalTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: normalPurplePrimary,
      scaffoldBackgroundColor: normalBackground,
      colorScheme: const ColorScheme.light(
        primary: normalPurplePrimary,
        secondary: normalOrangePrimary,
        surface: normalCardBg,
        error: error,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ).apply(bodyColor: normalTextPrimary, displayColor: normalTextPrimary),
      cardTheme: CardThemeData(
        color: normalCardBg,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: normalPurpleDark,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: normalOrangePrimary, width: 2),
        ),
      ),
    );
  }
}
