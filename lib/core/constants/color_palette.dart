import 'package:flutter/material.dart';

/// Color palette for watch face customization
class ColorPalette {
  /// Available colors for the watch face
  static const List<Color> colors = [
    Color(0xFFFFFFFF), // Pure White (default)
    Color(0xFF00FFB0), // Neon Mint
    Color(0xFF00BFFF), // Neon Cyan
    Color(0xFF1E90FF), // Deep Sky Blue
    Color(0xFF00CED1), // Dark Turquoise
    Color(0xFF00FFFF), // Aqua Cyan
    Color(0xFF40E0D0), // Turquoise
    Color(0xFF5F9EA0), // Cadet Blue
    Color(0xFFFF4B4B), // Neon Red
    Color(0xFFFF1493), // Deep Pink
    Color(0xFFFF6B6B), // Coral Red
    Color(0xFFFF0080), // Bright Pink
    Color(0xFFFF69B4), // Hot Pink
    Color(0xFFFF8C00), // Dark Orange
    Color(0xFFFFD700), // Gold
    Color(0xFFFFA500), // Orange
    Color(0xFFFFFF00), // Pure Yellow
    Color(0xFFFFFACD), // Lemon Chiffon
    Color(0xFF00FF00), // Lime Green
    Color(0xFF32CD32), // Lime
    Color(0xFF7FFF00), // Chartreuse
    Color(0xFFADFF2F), // Green Yellow
    Color(0xFF00FA9A), // Medium Spring Green
    Color(0xFF3CB371), // Medium Sea Green
    Color(0xFF9370DB), // Medium Purple
    Color(0xFF8A2BE2), // Blue Violet
    Color(0xFFDA70D6), // Orchid
    Color(0xFFFF00FF), // Magenta
    Color(0xFFBA55D3), // Medium Orchid
    Color(0xFFDDA0DD), // Plum
    Color(0xFFE0115F), // Ruby
    Color(0xFFDC143C), // Crimson
    Color(0xFFFF6347), // Tomato
    Color(0xFFFF7F50), // Coral
    Color(0xFFFFA07A), // Light Salmon
    Color(0xFFFFB6C1), // Light Pink
  ];

  /// Get color by index
  static Color getColor(int index) {
    if (index < 0 || index >= colors.length) {
      return colors[0]; // Return white as default
    }
    return colors[index];
  }

  /// Get the actual color to use (either from palette or custom)
  static Color getActiveColor(int index, int? customColorValue) {
    // If custom color is set and index is -1, use custom color
    if (index == -1 && customColorValue != null) {
      return Color(customColorValue);
    }
    return getColor(index);
  }

  /// Get color name for display
  static String getColorName(int index) {
    const names = [
      'Pure White',
      'Neon Mint',
      'Neon Cyan',
      'Sky Blue',
      'Turquoise',
      'Aqua Cyan',
      'Turquoise',
      'Cadet Blue',
      'Neon Red',
      'Deep Pink',
      'Coral Red',
      'Bright Pink',
      'Hot Pink',
      'Dark Orange',
      'Gold',
      'Orange',
      'Pure Yellow',
      'Lemon',
      'Lime Green',
      'Lime',
      'Chartreuse',
      'Yellow Green',
      'Spring Green',
      'Sea Green',
      'Purple',
      'Blue Violet',
      'Orchid',
      'Magenta',
      'Medium Orchid',
      'Plum',
      'Ruby',
      'Crimson',
      'Tomato',
      'Coral',
      'Light Salmon',
      'Light Pink',
    ];
    if (index < 0 || index >= names.length) {
      return 'Pure White';
    }
    return names[index];
  }
}
