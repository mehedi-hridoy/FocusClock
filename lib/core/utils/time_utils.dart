import 'package:intl/intl.dart';

/// Utility functions for time formatting and timezone handling
class TimeUtils {
  // Private constructor to prevent instantiation
  TimeUtils._();

  /// Format time in HH:mm:ss format
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  /// Format time in HH:mm format
  static String formatTimeShort(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Format date in readable format
  static String formatDate(DateTime dateTime) {
    return DateFormat('EEEE, MMMM d, y').format(dateTime);
  }

  /// Format date short
  static String formatDateShort(DateTime dateTime) {
    return DateFormat('MMM d, y').format(dateTime);
  }

  /// Get timezone name
  static String getTimezoneName(DateTime dateTime) {
    return dateTime.timeZoneName;
  }

  /// Get timezone offset in hours
  static String getTimezoneOffset(DateTime dateTime) {
    final offset = dateTime.timeZoneOffset;
    final hours = offset.inHours;
    final minutes = offset.inMinutes.remainder(60).abs();
    final sign = hours >= 0 ? '+' : '-';
    return '$sign${hours.abs().toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  /// Format duration for timer display (HH:mm:ss)
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  /// Format duration for timer display (mm:ss)
  static String formatDurationShort(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  /// Parse duration from string (HH:mm:ss)
  static Duration parseDuration(String durationString) {
    final parts = durationString.split(':');
    if (parts.length == 3) {
      final hours = int.tryParse(parts[0]) ?? 0;
      final minutes = int.tryParse(parts[1]) ?? 0;
      final seconds = int.tryParse(parts[2]) ?? 0;
      return Duration(hours: hours, minutes: minutes, seconds: seconds);
    }
    return Duration.zero;
  }

  /// Get current date time in specific timezone
  /// Note: For proper timezone conversion, consider using timezone package
  static DateTime getTimeInTimezone(String timezone) {
    // For Dhaka, Bangladesh (Asia/Dhaka) UTC+6
    if (timezone == 'Asia/Dhaka') {
      final utcNow = DateTime.now().toUtc();
      return utcNow.add(const Duration(hours: 6));
    }
    // Default to local time
    return DateTime.now();
  }

  /// Check if time is AM or PM
  static String getAmPm(DateTime dateTime) {
    return DateFormat('a').format(dateTime);
  }

  /// Format time in 12-hour format
  static String formatTime12Hour(DateTime dateTime) {
    return DateFormat('hh:mm:ss a').format(dateTime);
  }
}
