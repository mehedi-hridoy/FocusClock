import 'package:flutter/material.dart';

/// Utility class for orientation-responsive sizing
class OrientationUtils {
  /// Check if device is in portrait mode
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Get font size based on orientation
  static double getFontSize(
    BuildContext context, {
    required double landscapeSize,
    required double portraitSize,
  }) {
    return isPortrait(context) ? portraitSize : landscapeSize;
  }

  /// Get spacing based on orientation
  static double getSpacing(
    BuildContext context, {
    required double landscapeSpacing,
    required double portraitSpacing,
  }) {
    return isPortrait(context) ? portraitSpacing : landscapeSpacing;
  }

  /// Get width based on orientation
  static double getWidth(
    BuildContext context, {
    required double landscapeWidth,
    required double portraitWidth,
  }) {
    return isPortrait(context) ? portraitWidth : landscapeWidth;
  }

  /// Get screen width
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Get responsive value based on screen size
  static double getResponsiveValue(
    BuildContext context, {
    required double baseValue,
    double scaleFactor = 1.0,
  }) {
    final screenWidth = getScreenWidth(context);
    final isPortraitMode = isPortrait(context);

    if (isPortraitMode) {
      // In portrait, scale based on width (narrower)
      return baseValue * (screenWidth / 540) * scaleFactor;
    } else {
      // In landscape, scale based on width
      return baseValue * (screenWidth / 960) * scaleFactor;
    }
  }
}
