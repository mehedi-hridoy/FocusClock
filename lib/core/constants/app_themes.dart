import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

/// App theme configuration
class AppThemes {
  // Private constructor to prevent instantiation
  AppThemes._();

  /// Dark Neon Minimalism Theme
  static ThemeData darkNeonTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primaryNeon,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryNeon,
      secondary: AppColors.accentNeon,
      surface: AppColors.background,
      error: AppColors.timerActive,
      onPrimary: AppColors.black,
      onSecondary: AppColors.black,
      onSurface: AppColors.secondaryText,
      onError: AppColors.white,
    ),
    useMaterial3: true,

    // AppBar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),

    // Bottom Navigation Bar theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.primaryNeon,
      unselectedItemColor: AppColors.secondaryText,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),

    // Elevated Button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonBackground,
        foregroundColor: AppColors.primaryNeon,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.primaryNeon, width: 1.5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),

    // Icon theme
    iconTheme: const IconThemeData(color: AppColors.primaryNeon),
  );

  /// System UI overlay style for landscape mode
  static const SystemUiOverlayStyle landscapeOverlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.background,
    systemNavigationBarIconBrightness: Brightness.light,
  );
}
