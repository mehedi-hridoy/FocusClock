import 'package:flutter/material.dart';
import '../../data/models/watch_face.dart';
import '../../presentation/widgets/watch_faces.dart';

/// Watch faces manager
class WatchFacesManager {
  static final List<WatchFace> allWatchFaces = [
    WatchFace(
      id: 'neon_cyan',
      name: 'Neon Cyan',
      description: 'Electric mint glow effect',
      icon: Icons.gradient,
      primaryColor: const Color(0xFF00FFB0),
      builder: (time, date, brightness, is24Hour) =>
          NeonCyanWatchFace(time: time, date: date, brightness: brightness),
    ),
    WatchFace(
      id: 'led_white',
      name: 'LED White',
      description: 'Classic LED table clock',
      icon: Icons.brightness_7,
      primaryColor: Colors.white,
      builder: (time, date, brightness, is24Hour) =>
          LEDWhiteWatchFace(time: time, date: date, brightness: brightness),
    ),
    WatchFace(
      id: 'red_classic',
      name: 'Red Classic',
      description: 'Traditional alarm clock',
      icon: Icons.alarm,
      primaryColor: const Color(0xFFFF0000),
      builder: (time, date, brightness, is24Hour) =>
          RedClassicWatchFace(time: time, date: date, brightness: brightness),
    ),
    WatchFace(
      id: 'gradient_modern',
      name: 'Gradient Modern',
      description: 'Cyan to blue gradient',
      icon: Icons.auto_awesome,
      primaryColor: const Color(0xFF00BFFF),
      secondaryColor: const Color(0xFF1E90FF),
      builder: (time, date, brightness, is24Hour) => GradientModernWatchFace(
        time: time,
        date: date,
        brightness: brightness,
      ),
    ),
    WatchFace(
      id: 'segmented_display',
      name: 'Segmented Display',
      description: 'Classic 7-segment LED',
      icon: Icons.grid_4x4,
      primaryColor: const Color(0xFF00FFB0),
      builder: (time, date, brightness, is24Hour) => SegmentedDisplayWatchFace(
        time: time,
        date: date,
        brightness: brightness,
      ),
    ),
  ];

  /// Get watch face by ID
  static WatchFace? getWatchFaceById(String id) {
    try {
      return allWatchFaces.firstWhere((face) => face.id == id);
    } catch (e) {
      return allWatchFaces.first; // Return default
    }
  }

  /// Get watch face widget
  static Widget getWatchFaceWidget({
    required String id,
    required String time,
    required String date,
    required double brightness,
    required bool is24Hour,
  }) {
    final watchFace = getWatchFaceById(id);
    if (watchFace == null) {
      return allWatchFaces.first.builder(time, date, brightness, is24Hour);
    }
    return watchFace.builder(time, date, brightness, is24Hour);
  }
}
