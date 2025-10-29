/// Alarm model to represent an alarm
class AlarmModel {
  final String id;
  final int hour;
  final int minute;
  final bool isAM; // true for AM, false for PM
  final bool isEnabled;
  final String label;
  final bool vibrate;
  final bool deleteAfterGoesOff;
  final String ringtone;
  final List<bool> repeatDays; // 7 days: Mon-Sun

  AlarmModel({
    required this.id,
    required this.hour,
    required this.minute,
    required this.isAM,
    this.isEnabled = true,
    this.label = '',
    this.vibrate = true,
    this.deleteAfterGoesOff = false,
    this.ringtone = 'Weather alarm',
    List<bool>? repeatDays,
  }) : repeatDays =
           repeatDays ?? [false, false, false, false, false, false, false];

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hour': hour,
      'minute': minute,
      'isAM': isAM,
      'isEnabled': isEnabled,
      'label': label,
      'vibrate': vibrate,
      'deleteAfterGoesOff': deleteAfterGoesOff,
      'ringtone': ringtone,
      'repeatDays': repeatDays,
    };
  }

  // Create from JSON
  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      id: json['id'] as String,
      hour: json['hour'] as int,
      minute: json['minute'] as int,
      isAM: json['isAM'] as bool,
      isEnabled: json['isEnabled'] as bool? ?? true,
      label: json['label'] as String? ?? '',
      vibrate: json['vibrate'] as bool? ?? true,
      deleteAfterGoesOff: json['deleteAfterGoesOff'] as bool? ?? false,
      ringtone: json['ringtone'] as String? ?? 'Weather alarm',
      repeatDays:
          (json['repeatDays'] as List<dynamic>?)
              ?.map((e) => e as bool)
              .toList() ??
          [false, false, false, false, false, false, false],
    );
  }

  // Copy with method for updates
  AlarmModel copyWith({
    String? id,
    int? hour,
    int? minute,
    bool? isAM,
    bool? isEnabled,
    String? label,
    bool? vibrate,
    bool? deleteAfterGoesOff,
    String? ringtone,
    List<bool>? repeatDays,
  }) {
    return AlarmModel(
      id: id ?? this.id,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      isAM: isAM ?? this.isAM,
      isEnabled: isEnabled ?? this.isEnabled,
      label: label ?? this.label,
      vibrate: vibrate ?? this.vibrate,
      deleteAfterGoesOff: deleteAfterGoesOff ?? this.deleteAfterGoesOff,
      ringtone: ringtone ?? this.ringtone,
      repeatDays: repeatDays ?? this.repeatDays,
    );
  }

  // Get formatted time string (e.g., "05:26 am")
  String getFormattedTime() {
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');
    final period = isAM ? 'am' : 'pm';
    return '$hourStr:$minuteStr $period';
  }

  // Get repeat days as string (e.g., "Mon, Wed, Fri")
  String getRepeatDaysString() {
    if (repeatDays.every((day) => !day)) {
      return 'Once';
    }

    if (repeatDays.every((day) => day)) {
      return 'Every day';
    }

    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final selectedDays = <String>[];
    for (int i = 0; i < repeatDays.length; i++) {
      if (repeatDays[i]) {
        selectedDays.add(days[i]);
      }
    }
    return selectedDays.join(', ');
  }

  // Calculate next alarm DateTime
  DateTime getNextAlarmTime() {
    final now = DateTime.now();
    var hour24 = hour;
    if (!isAM && hour != 12) {
      hour24 += 12;
    } else if (isAM && hour == 12) {
      hour24 = 0;
    }

    var alarmTime = DateTime(now.year, now.month, now.day, hour24, minute);

    // If alarm time has passed today, move to tomorrow
    if (alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }

    // If repeat is set, find next valid day
    if (repeatDays.any((day) => day)) {
      while (!repeatDays[(alarmTime.weekday - 1) % 7]) {
        alarmTime = alarmTime.add(const Duration(days: 1));
      }
    }

    return alarmTime;
  }

  // Get time until alarm in human readable format
  String getTimeUntilAlarm() {
    final nextAlarm = getNextAlarmTime();
    final now = DateTime.now();
    final difference = nextAlarm.difference(now);

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    if (hours > 0) {
      return 'Alarm in $hours hours $minutes minutes';
    } else {
      return 'Alarm in $minutes minutes';
    }
  }
}
