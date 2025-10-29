import 'package:flutter/material.dart';
import 'dart:async';
import '../data/models/reminder_model.dart';
import '../data/services/reminder_service.dart';
import '../core/services/reminder_alarm_service.dart';

/// Provider for managing reminders
class ReminderProvider extends ChangeNotifier {
  final ReminderService _reminderService = ReminderService();
  final ReminderAlarmService _reminderAlarmService = ReminderAlarmService();
  List<ReminderModel> _reminders = [];
  bool _isLoading = false;
  Timer? _checkTimer;
  final Set<String> _triggeredReminders = {};

  List<ReminderModel> get reminders => _reminders;
  bool get isLoading => _isLoading;

  /// Get active reminders only
  List<ReminderModel> get activeReminders =>
      _reminders.where((r) => r.isActive && !r.isPast).toList();

  /// Get past reminders
  List<ReminderModel> get pastReminders =>
      _reminders.where((r) => r.isPast).toList();

  /// Initialize and load reminders
  Future<void> initialize() async {
    await loadReminders();
    _startReminderChecker();
  }

  @override
  void dispose() {
    _checkTimer?.cancel();
    super.dispose();
  }

  /// Load all reminders
  Future<void> loadReminders() async {
    _isLoading = true;
    notifyListeners();

    try {
      _reminders = await _reminderService.getReminders();
      // Sort by date time
      _reminders.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    } catch (e) {
      debugPrint('Error loading reminders: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Add a new reminder
  Future<void> addReminder({
    required String title,
    String? description,
    required DateTime dateTime,
  }) async {
    final reminder = ReminderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      dateTime: dateTime,
      createdAt: DateTime.now(),
    );

    await _reminderService.saveReminder(reminder);
    await loadReminders();
  }

  /// Update an existing reminder
  Future<void> updateReminder(ReminderModel reminder) async {
    await _reminderService.updateReminder(reminder);
    await loadReminders();
  }

  /// Delete a reminder
  Future<void> deleteReminder(String id) async {
    // Stop if this reminder is currently playing
    if (_reminderAlarmService.currentReminderId == id) {
      await _reminderAlarmService.stopReminderAlarm();
    }

    await _reminderService.deleteReminder(id);
    await loadReminders();
  }

  /// Toggle reminder active/inactive
  Future<void> toggleReminder(String id) async {
    await _reminderService.toggleReminder(id);
    await loadReminders();
  }

  /// Delete all past reminders
  Future<void> deletePastReminders() async {
    await _reminderService.deletePastReminders();
    await loadReminders();
  }

  /// Clear all reminders
  Future<void> clearAllReminders() async {
    await _reminderAlarmService.stopReminderAlarm();
    await _reminderService.clearAllReminders();
    await loadReminders();
  }

  /// Get reminders for a specific date
  List<ReminderModel> getRemindersForDate(DateTime date) {
    final targetDate = DateTime(date.year, date.month, date.day);
    return _reminders.where((r) {
      final reminderDate = DateTime(
        r.dateTime.year,
        r.dateTime.month,
        r.dateTime.day,
      );
      return reminderDate == targetDate;
    }).toList();
  }

  // Start checking for reminders every second
  void _startReminderChecker() {
    _checkTimer?.cancel();
    _checkTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkReminders();
    });
  }

  // Check if any reminder should trigger
  void _checkReminders() {
    final now = DateTime.now();

    // Debug: Print current time and active reminders every minute at :00 seconds
    if (_reminders.isNotEmpty && now.second == 0) {
      debugPrint(
        '⏰ Checking reminders at ${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}',
      );
      for (var reminder in _reminders) {
        if (reminder.isActive && !reminder.isPast) {
          debugPrint('  📋 Active Reminder: ${reminder.title}');
          debugPrint(
            '     Scheduled: ${reminder.dateTime.year}-${reminder.dateTime.month}-${reminder.dateTime.day} ${reminder.dateTime.hour}:${reminder.dateTime.minute}',
          );
          debugPrint(
            '     Time remaining: ${reminder.getTimeRemainingString()}',
          );
        }
      }
    }

    for (var reminder in _reminders) {
      if (!reminder.isActive || reminder.isPast) {
        if (now.second == 0 && reminder.isActive) {
          debugPrint('  ⏭️  Skipping past reminder: ${reminder.title}');
        }
        continue;
      }

      // Create unique identifier for this reminder trigger (date + time + id)
      final triggerId =
          '${now.year}-${now.month}-${now.day}-${now.hour}-${now.minute}-${reminder.id}';

      // Skip if already triggered
      if (_triggeredReminders.contains(triggerId)) {
        continue;
      }

      // Check if current time matches reminder time (within the same minute)
      final timeMatches =
          now.year == reminder.dateTime.year &&
          now.month == reminder.dateTime.month &&
          now.day == reminder.dateTime.day &&
          now.hour == reminder.dateTime.hour &&
          now.minute == reminder.dateTime.minute;

      if (timeMatches) {
        debugPrint('✅ TIME MATCH! Triggering reminder: ${reminder.title}');
        debugPrint(
          '   Current: ${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}',
        );
        debugPrint(
          '   Reminder: ${reminder.dateTime.year}-${reminder.dateTime.month}-${reminder.dateTime.day} ${reminder.dateTime.hour}:${reminder.dateTime.minute}',
        );
        _triggerReminder(reminder);
        _triggeredReminders.add(triggerId);
      }
    }

    // Clean up old triggered reminders (keep only today's)
    _triggeredReminders.removeWhere((id) {
      final parts = id.split('-');
      if (parts.length < 3) return true;
      final year = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final day = int.tryParse(parts[2]);
      if (year == null || month == null || day == null) return true;
      return year != now.year || month != now.month || day != now.day;
    });
  }

  // Trigger reminder (play sound and vibrate)
  void _triggerReminder(ReminderModel reminder) {
    debugPrint('🔔 Triggering reminder: ${reminder.title}');

    // Play alarm sound and vibrate using the same system as alarms
    _reminderAlarmService.playReminderAlarm(
      reminder.id,
      reminder.title,
      reminder.description,
    );
  }

  /// Stop the currently playing reminder alarm
  Future<void> stopReminderAlarm() async {
    await _reminderAlarmService.stopReminderAlarm();
  }

  /// Check if a reminder alarm is currently playing
  bool get isReminderPlaying => _reminderAlarmService.isPlaying;
}
