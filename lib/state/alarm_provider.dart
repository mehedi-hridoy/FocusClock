import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:vibration/vibration.dart';
import '../data/models/alarm_model.dart';
import '../data/services/notification_service.dart';

/// Provider to manage alarms
class AlarmProvider with ChangeNotifier {
  List<AlarmModel> _alarms = [];
  Timer? _checkTimer;
  AlarmModel? _ringingAlarm;
  final Set<String> _triggeredAlarms = {};
  final NotificationService _notificationService = NotificationService();

  List<AlarmModel> get alarms => _alarms;
  AlarmModel? get ringingAlarm => _ringingAlarm;
  bool get hasRingingAlarm => _ringingAlarm != null;

  AlarmProvider() {
    _notificationService.initialize();
    _loadAlarms();
    _startAlarmChecker();
  }

  // Load alarms from SharedPreferences
  Future<void> _loadAlarms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final alarmsJson = prefs.getStringList('alarms') ?? [];
      _alarms = alarmsJson
          .map((jsonStr) => AlarmModel.fromJson(json.decode(jsonStr)))
          .toList();
      _alarms.sort(
        (a, b) => a.getNextAlarmTime().compareTo(b.getNextAlarmTime()),
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading alarms: $e');
    }
  }

  // Save alarms to SharedPreferences
  Future<void> _saveAlarms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final alarmsJson = _alarms
          .map((alarm) => json.encode(alarm.toJson()))
          .toList();
      await prefs.setStringList('alarms', alarmsJson);
    } catch (e) {
      debugPrint('Error saving alarms: $e');
    }
  }

  // Add new alarm
  Future<void> addAlarm(AlarmModel alarm) async {
    _alarms.add(alarm);
    _alarms.sort(
      (a, b) => a.getNextAlarmTime().compareTo(b.getNextAlarmTime()),
    );
    await _saveAlarms();
    notifyListeners();
  }

  // Update existing alarm
  Future<void> updateAlarm(String id, AlarmModel updatedAlarm) async {
    final index = _alarms.indexWhere((alarm) => alarm.id == id);
    if (index != -1) {
      _alarms[index] = updatedAlarm;
      _alarms.sort(
        (a, b) => a.getNextAlarmTime().compareTo(b.getNextAlarmTime()),
      );
      await _saveAlarms();
      notifyListeners();
    }
  }

  // Delete alarm
  Future<void> deleteAlarm(String id) async {
    _alarms.removeWhere((alarm) => alarm.id == id);
    await _saveAlarms();
    notifyListeners();
  }

  // Toggle alarm on/off
  Future<void> toggleAlarm(String id) async {
    final index = _alarms.indexWhere((alarm) => alarm.id == id);
    if (index != -1) {
      _alarms[index] = _alarms[index].copyWith(
        isEnabled: !_alarms[index].isEnabled,
      );
      await _saveAlarms();
      notifyListeners();
    }
  }

  // Start checking for alarms every second
  void _startAlarmChecker() {
    _checkTimer?.cancel();
    _checkTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkAlarms();
    });
  }

  // Check if any alarm should trigger
  void _checkAlarms() {
    final now = DateTime.now();

    for (var alarm in _alarms) {
      if (!alarm.isEnabled) continue;

      // Create unique identifier for this alarm trigger (date + id)
      final triggerId =
          '${now.year}-${now.month}-${now.day}-${now.hour}-${now.minute}-${alarm.id}';

      // Skip if already triggered
      if (_triggeredAlarms.contains(triggerId)) continue;

      var hour24 = alarm.hour;
      if (!alarm.isAM && alarm.hour != 12) {
        hour24 += 12;
      } else if (alarm.isAM && alarm.hour == 12) {
        hour24 = 0;
      }

      // Check if current time matches alarm time (within the same minute)
      if (now.hour == hour24 && now.minute == alarm.minute) {
        // Check if alarm should repeat on this day
        final weekday = (now.weekday - 1) % 7; // Monday = 0, Sunday = 6
        final shouldRepeat = alarm.repeatDays.any((day) => day);

        if (!shouldRepeat || alarm.repeatDays[weekday]) {
          _triggerAlarm(alarm);
          _triggeredAlarms.add(triggerId);

          // Delete alarm if set to delete after goes off and not repeating
          if (alarm.deleteAfterGoesOff && !shouldRepeat) {
            deleteAlarm(alarm.id);
          }
        }
      }
    }

    // Clean up old triggered alarms (keep only today's)
    _triggeredAlarms.removeWhere((id) {
      final parts = id.split('-');
      if (parts.length < 3) return true;
      final year = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final day = int.tryParse(parts[2]);
      if (year == null || month == null || day == null) return true;
      return year != now.year || month != now.month || day != now.day;
    });
  }

  // Trigger alarm (play sound and vibrate)
  void _triggerAlarm(AlarmModel alarm) {
    _ringingAlarm = alarm;
    notifyListeners();

    // Show notification
    _notificationService.showAlarmNotification(
      id: alarm.id.hashCode,
      title: 'Alarm',
      body: alarm.label.isNotEmpty ? alarm.label : alarm.getFormattedTime(),
    );

    // Play ringtone
    FlutterRingtonePlayer().playAlarm(volume: 0.8, looping: true);

    // Vibrate if enabled
    if (alarm.vibrate) {
      _startVibration();
    }
  }

  // Start continuous vibration
  void _startVibration() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      // Vibrate in pattern: 500ms on, 200ms off, repeat
      Vibration.vibrate(pattern: [500, 200], repeat: 0);
    }
  }

  // Stop alarm
  Future<void> stopAlarm() async {
    if (_ringingAlarm != null) {
      // Cancel notification
      await _notificationService.cancelNotification(_ringingAlarm!.id.hashCode);

      // Stop ringtone
      FlutterRingtonePlayer().stop();

      // Stop vibration
      Vibration.cancel();

      _ringingAlarm = null;
      notifyListeners();
    }
  }

  // Snooze alarm (10 minutes)
  Future<void> snoozeAlarm() async {
    if (_ringingAlarm != null) {
      // Stop current alarm
      FlutterRingtonePlayer().stop();
      Vibration.cancel();

      // Create a snooze alarm (10 minutes from now)
      final now = DateTime.now();
      final snoozeTime = now.add(const Duration(minutes: 10));

      final snoozeAlarm = AlarmModel(
        id: '${_ringingAlarm!.id}_snooze_${DateTime.now().millisecondsSinceEpoch}',
        hour: snoozeTime.hour > 12
            ? snoozeTime.hour - 12
            : (snoozeTime.hour == 0 ? 12 : snoozeTime.hour),
        minute: snoozeTime.minute,
        isAM: snoozeTime.hour < 12,
        isEnabled: true,
        label: '${_ringingAlarm!.label} (Snoozed)',
        vibrate: _ringingAlarm!.vibrate,
        deleteAfterGoesOff: true,
        ringtone: _ringingAlarm!.ringtone,
      );

      await addAlarm(snoozeAlarm);

      _ringingAlarm = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _checkTimer?.cancel();
    super.dispose();
  }
}
