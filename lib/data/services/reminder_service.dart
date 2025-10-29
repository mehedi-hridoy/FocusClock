import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reminder_model.dart';

/// Service for managing reminders in local storage
class ReminderService {
  static const String _remindersKey = 'reminders';

  /// Get all reminders
  Future<List<ReminderModel>> getReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final remindersJson = prefs.getString(_remindersKey);

    if (remindersJson == null) {
      return [];
    }

    final List<dynamic> remindersList = jsonDecode(remindersJson);
    return remindersList
        .map((json) => ReminderModel.fromMap(json as Map<String, dynamic>))
        .toList();
  }

  /// Save a new reminder
  Future<void> saveReminder(ReminderModel reminder) async {
    final reminders = await getReminders();
    reminders.add(reminder);
    await _saveReminders(reminders);
  }

  /// Update an existing reminder
  Future<void> updateReminder(ReminderModel reminder) async {
    final reminders = await getReminders();
    final index = reminders.indexWhere((r) => r.id == reminder.id);

    if (index != -1) {
      reminders[index] = reminder;
      await _saveReminders(reminders);
    }
  }

  /// Delete a reminder
  Future<void> deleteReminder(String id) async {
    final reminders = await getReminders();
    reminders.removeWhere((r) => r.id == id);
    await _saveReminders(reminders);
  }

  /// Toggle reminder active state
  Future<void> toggleReminder(String id) async {
    final reminders = await getReminders();
    final index = reminders.indexWhere((r) => r.id == id);

    if (index != -1) {
      reminders[index] = reminders[index].copyWith(
        isActive: !reminders[index].isActive,
      );
      await _saveReminders(reminders);
    }
  }

  /// Delete all past reminders
  Future<void> deletePastReminders() async {
    final reminders = await getReminders();
    final activeReminders = reminders.where((r) => !r.isPast).toList();
    await _saveReminders(activeReminders);
  }

  /// Save reminders list to storage
  Future<void> _saveReminders(List<ReminderModel> reminders) async {
    final prefs = await SharedPreferences.getInstance();
    final remindersJson = jsonEncode(reminders.map((r) => r.toMap()).toList());
    await prefs.setString(_remindersKey, remindersJson);
  }

  /// Clear all reminders
  Future<void> clearAllReminders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_remindersKey);
  }
}
