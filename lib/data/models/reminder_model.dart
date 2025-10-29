/// Model for reminder/notification
class ReminderModel {
  final String id;
  final String title;
  final String? description;
  final DateTime dateTime;
  final bool isActive;
  final DateTime createdAt;

  const ReminderModel({
    required this.id,
    required this.title,
    this.description,
    required this.dateTime,
    this.isActive = true,
    required this.createdAt,
  });

  /// Create a copy with some fields updated
  ReminderModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dateTime,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from map
  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      dateTime: DateTime.parse(map['dateTime'] as String),
      isActive: map['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  @override
  String toString() {
    return 'ReminderModel(id: $id, title: $title, dateTime: $dateTime, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReminderModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.dateTime == dateTime &&
        other.isActive == isActive &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        dateTime.hashCode ^
        isActive.hashCode ^
        createdAt.hashCode;
  }

  /// Check if reminder is in the past (with 1 minute grace period for triggering)
  bool get isPast {
    final now = DateTime.now();
    // Allow triggering within the same minute - only consider past if more than 1 minute ago
    final scheduledMinute = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
    );
    final currentMinute = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    );
    return scheduledMinute.isBefore(currentMinute);
  }

  /// Get time remaining until reminder
  Duration get timeRemaining => dateTime.difference(DateTime.now());

  /// Format time remaining as countdown string
  String getTimeRemainingString() {
    if (isPast) return 'Past';

    final remaining = timeRemaining;

    // If time is negative (during trigger minute), show "Triggering..."
    if (remaining.isNegative) return 'Triggering...';

    if (remaining.inDays > 0) {
      final hours = remaining.inHours % 24;
      final minutes = remaining.inMinutes % 60;
      if (remaining.inDays == 1) {
        return '1 day ${hours}h ${minutes}m';
      }
      return '${remaining.inDays} days ${hours}h ${minutes}m';
    } else if (remaining.inHours > 0) {
      final minutes = remaining.inMinutes % 60;
      final seconds = remaining.inSeconds % 60;
      return '${remaining.inHours}h ${minutes}m ${seconds}s';
    } else if (remaining.inMinutes > 0) {
      final seconds = remaining.inSeconds % 60;
      return '${remaining.inMinutes}m ${seconds}s';
    } else {
      return '${remaining.inSeconds}s';
    }
  }

  /// Format date and time for display
  String getFormattedDateTime() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final reminderDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final daysDifference = reminderDate.difference(today).inDays;

    String dateStr;
    if (daysDifference == 0) {
      dateStr = 'Today';
    } else if (daysDifference == 1) {
      dateStr = 'Tomorrow';
    } else if (daysDifference < 7) {
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      dateStr = weekdays[dateTime.weekday - 1];
    } else {
      dateStr = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }

    final hour = dateTime.hour == 0
        ? 12
        : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$dateStr at $hour:$minute $period';
  }
}
