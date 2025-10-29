import 'package:flutter/material.dart';
import '../data/models/app_settings.dart';
import '../data/services/settings_service.dart';
import '../core/constants/color_palette.dart';

/// Provider for managing app settings
class SettingsProvider extends ChangeNotifier {
  final SettingsService _settingsService = SettingsService();

  AppSettings _settings = const AppSettings();

  AppSettings get settings => _settings;
  bool get is24HourFormat => _settings.is24HourFormat;
  double get brightness => _settings.brightness;
  String get selectedWatchFace => _settings.selectedWatchFace;
  String get selectedTimezone => _settings.selectedTimezone;
  int get selectedColorIndex => _settings.selectedColorIndex;
  int? get customColorValue => _settings.customColorValue;

  /// Initialize settings
  Future<void> initialize() async {
    await loadSettings();
  }

  /// Load settings from storage
  Future<void> loadSettings() async {
    _settings = await _settingsService.loadSettings();
    notifyListeners();
  }

  /// Save settings to storage
  Future<void> saveSettings() async {
    await _settingsService.saveSettings(_settings);
    notifyListeners();
  }

  /// Toggle 12H/24H format
  Future<void> toggleTimeFormat() async {
    _settings = _settings.copyWith(is24HourFormat: !_settings.is24HourFormat);
    await _settingsService.set24HourFormat(_settings.is24HourFormat);
    notifyListeners();
  }

  /// Set 24-hour format
  Future<void> set24HourFormat(bool is24Hour) async {
    _settings = _settings.copyWith(is24HourFormat: is24Hour);
    await _settingsService.set24HourFormat(is24Hour);
    notifyListeners();
  }

  /// Set brightness
  Future<void> setBrightness(double brightness) async {
    final clampedBrightness = brightness.clamp(0.1, 1.0);
    _settings = _settings.copyWith(brightness: clampedBrightness);
    await _settingsService.setBrightness(clampedBrightness);
    notifyListeners();
  }

  /// Set selected watch face
  Future<void> setSelectedWatchFace(String watchFaceId) async {
    _settings = _settings.copyWith(selectedWatchFace: watchFaceId);
    await _settingsService.setSelectedWatchFace(watchFaceId);
    notifyListeners();
  }

  /// Set selected timezone
  Future<void> setSelectedTimezone(String timezone) async {
    _settings = _settings.copyWith(selectedTimezone: timezone);
    await _settingsService.setSelectedTimezone(timezone);
    notifyListeners();
  }

  /// Set selected color index
  Future<void> setSelectedColorIndex(int colorIndex) async {
    _settings = _settings.copyWith(
      selectedColorIndex: colorIndex,
      customColorValue: null, // Clear custom color when selecting from palette
    );
    await saveSettings();
    notifyListeners();
  }

  /// Set custom color
  Future<void> setCustomColor(Color color) async {
    _settings = _settings.copyWith(
      customColorValue: color.value,
      selectedColorIndex: -1, // Use -1 to indicate custom color
    );
    await saveSettings();
    notifyListeners();
  }

  /// Clear custom color and revert to palette
  Future<void> clearCustomColor() async {
    _settings = _settings.copyWith(
      customColorValue: null,
      selectedColorIndex: 0, // Revert to white
    );
    await saveSettings();
    notifyListeners();
  }

  /// Get the active color (either from palette or custom)
  Color getActiveColor() {
    if (_settings.selectedColorIndex == -1 &&
        _settings.customColorValue != null) {
      return Color(_settings.customColorValue!);
    }
    return ColorPalette.getColor(_settings.selectedColorIndex);
  }

  /// Reset settings to defaults
  Future<void> resetSettings() async {
    await _settingsService.clearSettings();
    _settings = const AppSettings();
    notifyListeners();
  }

  /// Get time format string (12H or 24H)
  String getTimeFormatString() {
    return _settings.is24HourFormat ? '24H' : '12H';
  }

  /// Get brightness percentage
  int getBrightnessPercentage() {
    return (_settings.brightness * 100).round();
  }
}
