import 'dart:async';
import 'package:vibration/vibration.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service to handle alarm sound and vibration
class AlarmService {
  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  AlarmService._internal() {
    _initializeNotifications();
  }

  bool _isPlaying = false;
  Timer? _vibrationTimer;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

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
        // When user taps the notification, stop the alarm
        if (response.actionId == 'stop_alarm') {
          stopAlarm();
        }
      },
    );
  }

  /// Show persistent notification with stop button
  Future<void> _showAlarmNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'alarm_channel',
          'Alarm',
          channelDescription: 'Alarm notifications',
          importance: Importance.high,
          priority: Priority.high,
          ongoing: true, // Makes it persistent
          autoCancel: false,
          playSound: false, // We're handling sound separately
          enableVibration: false, // We're handling vibration separately
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction(
              'stop_alarm',
              'STOP ALARM',
              showsUserInterface: true,
              cancelNotification: true,
            ),
          ],
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      0, // notification ID
      'Timer Finished!',
      'Tap to stop the alarm',
      notificationDetails,
    );
  }

  /// Cancel the alarm notification
  Future<void> _cancelAlarmNotification() async {
    await _notificationsPlugin.cancel(0);
  }

  /// Play alarm sound and vibrate continuously
  Future<void> playAlarm() async {
    if (_isPlaying) return;

    _isPlaying = true;

    try {
      // Show persistent notification
      await _showAlarmNotification();

      // Start continuous vibration pattern
      _startContinuousVibration();

      // Play alarm sound with looping using flutter_ringtone_player
      FlutterRingtonePlayer().playAlarm(
        looping: true,
        volume: 1.0,
        asAlarm: true, // Ignore silent mode
      );
    } catch (e) {
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
      Vibration.vibrate(duration: 500, amplitude: 255);

      // Continue vibrating every 800ms (500ms vibrate + 300ms pause)
      _vibrationTimer = Timer.periodic(const Duration(milliseconds: 800), (
        timer,
      ) {
        if (_isPlaying) {
          Vibration.vibrate(duration: 500, amplitude: 255);
        } else {
          timer.cancel();
        }
      });
    }
  }

  /// Stop alarm sound and vibration
  Future<void> stopAlarm() async {
    if (!_isPlaying) return;

    _isPlaying = false;

    try {
      // Cancel alarm notification
      await _cancelAlarmNotification();

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

  /// Check if alarm is currently playing
  bool get isPlaying => _isPlaying;

  /// Dispose resources
  void dispose() {
    stopAlarm();
  }
}
