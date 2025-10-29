import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service to handle reminder sound and vibration
class ReminderAlarmService {
  static final ReminderAlarmService _instance =
      ReminderAlarmService._internal();
  factory ReminderAlarmService() => _instance;
  ReminderAlarmService._internal() {
    _initializeNotifications();
  }

  bool _isPlaying = false;
  Timer? _vibrationTimer;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? _currentReminderId;

  /// Initialize notifications
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // When user taps the notification, stop the reminder alarm
        if (response.actionId == 'stop_reminder') {
          stopReminderAlarm();
        }
      },
    );
  }

  /// Show persistent notification with stop button
  Future<void> _showReminderNotification(
    String title,
    String? description,
  ) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'reminder_alarm_channel',
          'Reminder Alarms',
          channelDescription: 'Active reminder notifications with sound',
          importance: Importance.max,
          priority: Priority.max,
          ongoing: true, // Makes it persistent
          autoCancel: false,
          playSound: false, // We're handling sound separately
          enableVibration: false, // We're handling vibration separately
          fullScreenIntent: true,
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction(
              'stop_reminder',
              'STOP REMINDER',
              showsUserInterface: true,
              cancelNotification: true,
            ),
          ],
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      999999, // Fixed ID for active reminder alarm
      title,
      description ?? 'Tap to stop the reminder',
      notificationDetails,
    );
  }

  /// Cancel the reminder notification
  Future<void> _cancelReminderNotification() async {
    await _notificationsPlugin.cancel(999999);
  }

  /// Play reminder sound and vibrate continuously
  Future<void> playReminderAlarm(
    String reminderId,
    String title,
    String? description,
  ) async {
    debugPrint('🔊 ReminderAlarmService: playReminderAlarm called');
    debugPrint('   Title: $title');
    debugPrint('   Already playing: $_isPlaying');

    if (_isPlaying) {
      // If already playing a reminder, stop it first
      debugPrint('   Stopping previous alarm first');
      await stopReminderAlarm();
    }

    _isPlaying = true;
    _currentReminderId = reminderId;

    try {
      // Show persistent notification
      debugPrint('   Showing notification...');
      await _showReminderNotification(title, description);

      // Start continuous vibration pattern
      debugPrint('   Starting vibration...');
      _startContinuousVibration();

      // Play ALARM sound with looping - SAME AS ALARM SERVICE
      debugPrint(
        '   Playing alarm sound with flutter_ringtone_player.playAlarm()',
      );
      FlutterRingtonePlayer().playAlarm(
        looping: true,
        volume: 1.0,
        asAlarm: true, // Ignore silent mode - IMPORTANT!
      );
      debugPrint('   ✅ Alarm sound started successfully!');
    } catch (e) {
      debugPrint('   ❌ ERROR playing alarm: $e');
      // If there's an error, try to at least vibrate
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator) {
        Vibration.vibrate(duration: 2000, amplitude: 255);
      }
    }
  }

  /// Start continuous vibration
  void _startContinuousVibration() async {
    final hasVibrator = await Vibration.hasVibrator();

    if (hasVibrator) {
      // Vibrate immediately
      Vibration.vibrate(duration: 1000, amplitude: 255);

      // Continue vibrating every 1.5 seconds (1000ms vibrate + 500ms pause)
      _vibrationTimer = Timer.periodic(const Duration(milliseconds: 1500), (
        timer,
      ) {
        if (_isPlaying) {
          Vibration.vibrate(duration: 1000, amplitude: 255);
        } else {
          timer.cancel();
        }
      });
    }
  }

  /// Stop reminder sound and vibration
  Future<void> stopReminderAlarm() async {
    if (!_isPlaying) return;

    _isPlaying = false;
    _currentReminderId = null;

    try {
      // Cancel reminder notification
      await _cancelReminderNotification();

      // Cancel vibration timer
      _vibrationTimer?.cancel();
      _vibrationTimer = null;

      // Stop ringtone player and vibration
      FlutterRingtonePlayer().stop();
      await Vibration.cancel();
    } catch (e) {
      // Silently handle errors
    }
  }

  /// Check if reminder alarm is currently playing
  bool get isPlaying => _isPlaying;

  /// Get current reminder ID
  String? get currentReminderId => _currentReminderId;

  /// Dispose resources
  void dispose() {
    stopReminderAlarm();
  }
}
