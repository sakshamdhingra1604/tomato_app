import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.scaffoldBg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryYellow,
      secondary: AppColors.secondaryOrange,
      surface: AppColors.surfaceBg,
    ),
    // Customizing Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.textPrimary),
    ),
    // Production-level Card Theme
    cardTheme: CardThemeData(
      color: AppColors.cardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryYellow,
        foregroundColor: Colors.black,
        minimumSize: const Size.fromHeight(55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}