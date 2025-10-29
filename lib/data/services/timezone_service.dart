import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing timezone settings
class TimezoneService {
  static const String _timezoneKey = 'selected_timezone';
  static const String _autoDetectKey = 'auto_detect_timezone';

  // Available timezones
  static const String timezoneAuto = 'auto';
  static const String timezoneDhaka = 'Asia/Dhaka';

  /// Get saved timezone preference
  Future<String> getSelectedTimezone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_timezoneKey) ?? timezoneAuto;
  }

  /// Save timezone preference
  Future<void> setSelectedTimezone(String timezone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_timezoneKey, timezone);
  }

  /// Get auto-detect setting
  Future<bool> getAutoDetect() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoDetectKey) ?? true;
  }

  /// Save auto-detect setting
  Future<void> setAutoDetect(bool autoDetect) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoDetectKey, autoDetect);
  }

  /// Get current time based on timezone setting
  Future<DateTime> getCurrentTime() async {
    final timezone = await getSelectedTimezone();

    if (timezone == timezoneDhaka) {
      // Dhaka is UTC+6
      final utcNow = DateTime.now().toUtc();
      return utcNow.add(const Duration(hours: 6));
    }

    // Default to local time (auto-detect)
    return DateTime.now();
  }

  /// Get timezone display name
  String getTimezoneDisplayName(String timezone) {
    switch (timezone) {
      case timezoneDhaka:
        return 'Dhaka, Bangladesh';
      case timezoneAuto:
        return 'Auto (${DateTime.now().timeZoneName})';
      default:
        return 'Local Time';
    }
  }

  /// Get timezone offset string
  String getTimezoneOffset(String timezone) {
    if (timezone == timezoneDhaka) {
      return 'UTC+06:00';
    }

    // For auto-detect, use local offset
    final offset = DateTime.now().timeZoneOffset;
    final hours = offset.inHours;
    final minutes = offset.inMinutes.remainder(60).abs();
    final sign = hours >= 0 ? '+' : '-';
    return 'UTC$sign${hours.abs().toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  /// Get list of available timezones
  List<Map<String, String>> getAvailableTimezones() {
    return [
      {
        'value': timezoneAuto,
        'label': 'Auto-Detect',
        'offset': getTimezoneOffset(timezoneAuto),
      },
      {
        'value': timezoneDhaka,
        'label': 'Dhaka, Bangladesh',
        'offset': 'UTC+06:00',
      },
    ];
  }
}
