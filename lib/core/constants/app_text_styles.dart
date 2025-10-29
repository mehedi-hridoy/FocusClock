import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// App text styles using Google Fonts
class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  // Digital-style numbers using Orbitron
  static TextStyle digitalClock({
    double fontSize = 80,
    Color color = AppColors.primaryNeon,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return GoogleFonts.orbitron(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      letterSpacing: 4.0,
      shadows: [
        Shadow(
          color: color.withOpacity(0.8),
          blurRadius: 20,
          offset: const Offset(0, 0),
        ),
        Shadow(
          color: color.withOpacity(0.5),
          blurRadius: 40,
          offset: const Offset(0, 0),
        ),
      ],
    );
  }

  // Clean minimal time font using Roboto Mono
  static TextStyle robotoMono({
    double fontSize = 16,
    Color color = AppColors.secondaryText,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return GoogleFonts.robotoMono(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );
  }

  // Timer display
  static TextStyle timerDisplay({
    double fontSize = 72,
    Color color = AppColors.accentNeon,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return GoogleFonts.orbitron(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      letterSpacing: 3.0,
      shadows: [
        Shadow(
          color: color.withOpacity(0.8),
          blurRadius: 15,
          offset: const Offset(0, 0),
        ),
      ],
    );
  }

  // Button text
  static TextStyle buttonText({
    double fontSize = 16,
    Color color = AppColors.primaryNeon,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return GoogleFonts.robotoMono(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      letterSpacing: 1.5,
    );
  }

  // Label text
  static TextStyle label({
    double fontSize = 14,
    Color color = AppColors.secondaryText,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return GoogleFonts.robotoMono(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );
  }

  // Title text
  static TextStyle title({
    double fontSize = 24,
    Color color = AppColors.primaryNeon,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return GoogleFonts.orbitron(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      letterSpacing: 2.0,
    );
  }
}
