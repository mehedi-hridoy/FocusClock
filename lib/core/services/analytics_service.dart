import 'package:firebase_analytics/firebase_analytics.dart';

/// Service to handle Firebase Analytics events
class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Log when app is opened
  static Future<void> logAppOpen() async {
    await _analytics.logAppOpen();
  }

  // Log when a feature is used
  static Future<void> logFeatureUsed(String featureName) async {
    await _analytics.logEvent(
      name: 'feature_used',
      parameters: {'feature': featureName},
    );
  }

  // Log when clock face is changed
  static Future<void> logClockFaceChanged(String faceType) async {
    await _analytics.logEvent(
      name: 'clock_face_changed',
      parameters: {'face_type': faceType},
    );
  }

  // Log when timer is started
  static Future<void> logTimerStarted(int durationSeconds) async {
    await _analytics.logEvent(
      name: 'timer_started',
      parameters: {'duration_seconds': durationSeconds},
    );
  }

  // Log when stopwatch is used
  static Future<void> logStopwatchUsed() async {
    await _analytics.logEvent(name: 'stopwatch_used');
  }

  // Log when alarm is set
  static Future<void> logAlarmSet(String time) async {
    await _analytics.logEvent(name: 'alarm_set', parameters: {'time': time});
  }

  // Log when reminder is created
  static Future<void> logReminderCreated() async {
    await _analytics.logEvent(name: 'reminder_created');
  }

  // Log when color is changed
  static Future<void> logColorChanged(String colorName) async {
    await _analytics.logEvent(
      name: 'color_changed',
      parameters: {'color': colorName},
    );
  }

  // Log when settings are changed
  static Future<void> logSettingsChanged(
    String settingName,
    dynamic value,
  ) async {
    await _analytics.logEvent(
      name: 'settings_changed',
      parameters: {'setting': settingName, 'value': value.toString()},
    );
  }

  // Set user properties (optional)
  static Future<void> setUserProperty(String name, String value) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  // Log screen views (automatically tracked by NavigatorObserver)
  static Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }
}
