import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class ApexTheme {
  ApexTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: ApexColors.primaryEmerald,
      colorScheme: const ColorScheme.light(
        primary: ApexColors.primaryEmerald,
        secondary: ApexColors.emeraldLight,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSurface: ApexColors.textPrimary,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: const TextStyle(
          color: ApexColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: const TextStyle(
          color: ApexColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: const TextStyle(
          color: ApexColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: const TextStyle(
          color: ApexColors.textPrimary,
        ),
        bodyMedium: const TextStyle(
          color: ApexColors.textSecondary,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: ApexColors.textPrimary),
        titleTextStyle: TextStyle(
          color: ApexColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
