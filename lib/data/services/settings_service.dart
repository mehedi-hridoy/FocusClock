import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';

/// Service for managing app settings
class SettingsService {
  static const String _is24HourFormatKey = 'is_24_hour_format';
  static const String _brightnessKey = 'brightness';
  static const String _selectedWatchFaceKey = 'selected_watch_face';
  static const String _selectedTimezoneKey = 'selected_timezone';

  /// Load settings from storage
  Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    return AppSettings(
      is24HourFormat: prefs.getBool(_is24HourFormatKey) ?? true,
      brightness: prefs.getDouble(_brightnessKey) ?? 1.0,
      selectedWatchFace: prefs.getString(_selectedWatchFaceKey) ?? 'neon_cyan',
      selectedTimezone: prefs.getString(_selectedTimezoneKey) ?? 'auto',
    );
  }

  /// Save settings to storage
  Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_is24HourFormatKey, settings.is24HourFormat);
    await prefs.setDouble(_brightnessKey, settings.brightness);
    await prefs.setString(_selectedWatchFaceKey, settings.selectedWatchFace);
    await prefs.setString(_selectedTimezoneKey, settings.selectedTimezone);
  }

  /// Save 24-hour format preference
  Future<void> set24HourFormat(bool is24Hour) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_is24HourFormatKey, is24Hour);
  }

  /// Get 24-hour format preference
  Future<bool> get24HourFormat() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_is24HourFormatKey) ?? true;
  }

  /// Save brightness
  Future<void> setBrightness(double brightness) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_brightnessKey, brightness.clamp(0.1, 1.0));
  }

  /// Get brightness
  Future<double> getBrightness() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_brightnessKey) ?? 1.0;
  }

  /// Save selected watch face
  Future<void> setSelectedWatchFace(String watchFaceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedWatchFaceKey, watchFaceId);
  }

  /// Get selected watch face
  Future<String> getSelectedWatchFace() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedWatchFaceKey) ?? 'neon_cyan';
  }

  /// Save selected timezone
  Future<void> setSelectedTimezone(String timezone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedTimezoneKey, timezone);
  }

  /// Get selected timezone
  Future<String> getSelectedTimezone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedTimezoneKey) ?? 'auto';
  }

  /// Clear all settings
  Future<void> clearSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_is24HourFormatKey);
    await prefs.remove(_brightnessKey);
    await prefs.remove(_selectedWatchFaceKey);
    await prefs.remove(_selectedTimezoneKey);
  }
}
