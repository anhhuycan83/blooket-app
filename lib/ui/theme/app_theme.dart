import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF4F46E5);       // Indigo
  static const Color primaryLight = Color(0xFFEEF2FF);
  static const Color primaryDark = Color(0xFF3730A3);

  static const Color secondary = Color(0xFF06B6D4);     // Cyan
  static const Color accent = Color(0xFFF59E0B);        // Amber / Gold
  static const Color accentDark = Color(0xFFD97706);

  static const Color success = Color(0xFF10B981);       // Emerald
  static const Color error = Color(0xFFEF4444);         // Rose/Red
  static const Color purple = Color(0xFF8B5CF6);

  // Blooket card background colors
  static const Color blooketRed = Color(0xFFE11D48);
  static const Color blooketBlue = Color(0xFF2563EB);
  static const Color blooketGreen = Color(0xFF059669);
  static const Color blooketYellow = Color(0xFFD97706);

  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color textMain = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);
}

class AppTheme {
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.quicksandTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        surface: AppColors.surface,
      ),
      textTheme: baseTextTheme.apply(
        bodyColor: AppColors.textMain,
        displayColor: AppColors.textMain,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textMain),
        titleTextStyle: TextStyle(
          color: AppColors.textMain,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
