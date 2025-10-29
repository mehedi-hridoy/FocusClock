import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:vibration/vibration.dart';
import 'dart:typed_data';
import '../models/reminder_model.dart';

/// Service to handle local notifications for alarms
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Initialize notification service
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone database for scheduled notifications
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for Android 13+
    await _requestPermissions();

    _initialized = true;
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      // Request notification permission for Android 13+
      final granted = await androidPlugin.requestNotificationsPermission();
      debugPrint('Notification permission granted: $granted');

      // Request exact alarm permission for scheduled notifications
      final exactAlarmGranted = await androidPlugin
          .requestExactAlarmsPermission();
      debugPrint('Exact alarm permission granted: $exactAlarmGranted');
    }

    final iosPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
        critical: true,
      );
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // Handle navigation or actions here
  }

  /// Show alarm notification
  Future<void> showAlarmNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await initialize();

    final androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Alarms',
      channelDescription: 'Notifications for alarms',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      ongoing: true, // Sticky notification
      autoCancel: false,
      colorized: true,
      color: const Color(0xFFFF0000), // Red color for alarm
      actions: <AndroidNotificationAction>[
        const AndroidNotificationAction(
          'snooze',
          'Snooze (10 min)',
          showsUserInterface: false,
          cancelNotification: false,
        ),
        const AndroidNotificationAction(
          'stop',
          'Stop',
          showsUserInterface: false,
          cancelNotification: true,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details, payload: 'alarm_$id');
  }

  /// Cancel alarm notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Schedule a reminder notification
  Future<void> scheduleReminder(ReminderModel reminder) async {
    await initialize();

    // Don't schedule if in the past
    if (reminder.isPast) {
      debugPrint('Cannot schedule past reminder');
      return;
    }

    final androidDetails = AndroidNotificationDetails(
      'reminders_channel',
      'Reminders',
      channelDescription: 'Notifications for reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification'),
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
      enableLights: true,
      color: const Color(0xFFFFAA00),
      ledColor: const Color(0xFFFFAA00),
      ledOnMs: 1000,
      ledOffMs: 500,
      category: AndroidNotificationCategory.reminder,
      fullScreenIntent: true,
      channelShowBadge: true,
      ongoing: false,
      autoCancel: true,
      styleInformation: BigTextStyleInformation(
        reminder.description ?? 'Reminder notification',
        contentTitle: reminder.title,
        summaryText: 'Tap to open',
      ),
      ticker: reminder.title,
      visibility: NotificationVisibility.public,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
      interruptionLevel: InterruptionLevel.timeSensitive,
      categoryIdentifier: 'reminder_category',
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      // Convert to timezone-aware DateTime
      final scheduledDate = tz.TZDateTime.from(reminder.dateTime, tz.local);

      // Generate a valid 32-bit integer ID from the reminder ID string
      final notificationId = reminder.id.hashCode.abs() & 0x7FFFFFFF;

      await _notifications.zonedSchedule(
        notificationId,
        reminder.title,
        reminder.description ?? 'Reminder notification',
        scheduledDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'reminder_${reminder.id}',
      );

      debugPrint(
        'Scheduled reminder: ${reminder.title} at ${reminder.dateTime} with ID: $notificationId',
      );

      // Vibrate briefly to confirm
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 100);
      }
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
      rethrow;
    }
  }

  /// Cancel a specific reminder notification
  Future<void> cancelReminder(String id) async {
    await initialize();

    try {
      // Generate the same 32-bit integer ID from the reminder ID string
      final notificationId = id.hashCode.abs() & 0x7FFFFFFF;
      await _notifications.cancel(notificationId);
      debugPrint('Cancelled reminder: $id (notification ID: $notificationId)');
    } catch (e) {
      debugPrint('Error cancelling notification: $e');
    }
  }

  /// Cancel all reminder notifications
  Future<void> cancelAllReminders() async {
    await initialize();

    final pending = await _notifications.pendingNotificationRequests();
    for (final request in pending) {
      if (request.payload?.startsWith('reminder_') ?? false) {
        await _notifications.cancel(request.id);
      }
    }
    debugPrint('Cancelled all reminders');
  }

  /// Show an immediate reminder notification (for testing)
  Future<void> showImmediateReminder({
    required String title,
    required String body,
    String? payload,
  }) async {
    await initialize();

    final androidDetails = AndroidNotificationDetails(
      'reminders_channel',
      'Reminders',
      channelDescription: 'Notifications for reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification'),
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
      enableLights: true,
      color: const Color(0xFFFFAA00),
      ticker: title,
      visibility: NotificationVisibility.public,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
      payload: payload,
    );

    // Vibrate
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 500, amplitude: 128);
    }
  }

  /// Get all pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    await initialize();
    return await _notifications.pendingNotificationRequests();
  }
}
