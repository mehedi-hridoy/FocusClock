/// Clock model to hold time and timezone information
class ClockModel {
  final DateTime currentTime;
  final String timezone;
  final String timezoneOffset;

  ClockModel({
    required this.currentTime,
    required this.timezone,
    required this.timezoneOffset,
  });

  /// Create a copy of the model with updated values
  ClockModel copyWith({
    DateTime? currentTime,
    String? timezone,
    String? timezoneOffset,
  }) {
    return ClockModel(
      currentTime: currentTime ?? this.currentTime,
      timezone: timezone ?? this.timezone,
      timezoneOffset: timezoneOffset ?? this.timezoneOffset,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'currentTime': currentTime.toIso8601String(),
      'timezone': timezone,
      'timezoneOffset': timezoneOffset,
    };
  }

  /// Create from map
  factory ClockModel.fromMap(Map<String, dynamic> map) {
    return ClockModel(
      currentTime: DateTime.parse(map['currentTime']),
      timezone: map['timezone'],
      timezoneOffset: map['timezoneOffset'],
    );
  }

  @override
  String toString() {
    return 'ClockModel(currentTime: $currentTime, timezone: $timezone, timezoneOffset: $timezoneOffset)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClockModel &&
        other.currentTime == currentTime &&
        other.timezone == timezone &&
        other.timezoneOffset == timezoneOffset;
  }

  @override
  int get hashCode {
    return currentTime.hashCode ^ timezone.hashCode ^ timezoneOffset.hashCode;
  }
}
