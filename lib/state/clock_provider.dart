import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/clock_model.dart';
import '../data/services/timezone_service.dart';
import '../core/utils/time_utils.dart';

/// Provider for managing clock state
class ClockProvider extends ChangeNotifier {
  final TimezoneService _timezoneService = TimezoneService();
  Timer? _timer;

  ClockModel _clockModel = ClockModel(
    currentTime: DateTime.now(),
    timezone: 'auto',
    timezoneOffset: TimeUtils.getTimezoneOffset(DateTime.now()),
  );

  ClockModel get clockModel => _clockModel;
  String get currentTimeString => TimeUtils.formatTime(_clockModel.currentTime);
  String get currentDateString => TimeUtils.formatDate(_clockModel.currentTime);
  String get timezoneString => _clockModel.timezone;
  String get timezoneOffsetString => _clockModel.timezoneOffset;

  /// Initialize the clock provider
  Future<void> initialize() async {
    await loadTimezonePreference();
    startClock();
  }

  /// Start the clock timer
  void startClock() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      await _updateTime();
    });
  }

  /// Stop the clock timer
  void stopClock() {
    _timer?.cancel();
  }

  /// Update the current time
  Future<void> _updateTime() async {
    final timezone = await _timezoneService.getSelectedTimezone();
    DateTime newTime;

    if (timezone == TimezoneService.timezoneDhaka) {
      // Dhaka is UTC+6
      final utcNow = DateTime.now().toUtc();
      newTime = utcNow.add(const Duration(hours: 6));
    } else {
      // Auto-detect (local time)
      newTime = DateTime.now();
    }

    _clockModel = _clockModel.copyWith(
      currentTime: newTime,
      timezoneOffset: TimeUtils.getTimezoneOffset(newTime),
    );

    notifyListeners();
  }

  /// Load timezone preference from storage
  Future<void> loadTimezonePreference() async {
    final timezone = await _timezoneService.getSelectedTimezone();
    _clockModel = _clockModel.copyWith(timezone: timezone);
    notifyListeners();
  }

  /// Set timezone
  Future<void> setTimezone(String timezone) async {
    await _timezoneService.setSelectedTimezone(timezone);
    _clockModel = _clockModel.copyWith(timezone: timezone);
    await _updateTime();
    notifyListeners();
  }

  /// Toggle between auto and Dhaka timezone
  Future<void> toggleTimezone() async {
    final currentTimezone = await _timezoneService.getSelectedTimezone();
    final newTimezone = currentTimezone == TimezoneService.timezoneAuto
        ? TimezoneService.timezoneDhaka
        : TimezoneService.timezoneAuto;
    await setTimezone(newTimezone);
  }

  /// Get timezone display name
  String getTimezoneDisplayName() {
    return _timezoneService.getTimezoneDisplayName(_clockModel.timezone);
  }

  /// Get available timezones
  List<Map<String, String>> getAvailableTimezones() {
    return _timezoneService.getAvailableTimezones();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
