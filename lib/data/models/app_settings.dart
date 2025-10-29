/// App settings model
class AppSettings {
  final bool is24HourFormat;
  final double brightness;
  final String selectedWatchFace;
  final String selectedTimezone;
  final int selectedColorIndex; // Index of selected color from color palette
  final int?
  customColorValue; // Custom RGB color value (null if not using custom)

  const AppSettings({
    this.is24HourFormat = true,
    this.brightness = 1.0,
    this.selectedWatchFace = 'led_white',
    this.selectedTimezone = 'auto',
    this.selectedColorIndex = 0, // Default to white
    this.customColorValue,
  });

  /// Create a copy with updated values
  AppSettings copyWith({
    bool? is24HourFormat,
    double? brightness,
    String? selectedWatchFace,
    String? selectedTimezone,
    int? selectedColorIndex,
    int? customColorValue,
  }) {
    return AppSettings(
      is24HourFormat: is24HourFormat ?? this.is24HourFormat,
      brightness: brightness ?? this.brightness,
      selectedWatchFace: selectedWatchFace ?? this.selectedWatchFace,
      selectedTimezone: selectedTimezone ?? this.selectedTimezone,
      selectedColorIndex: selectedColorIndex ?? this.selectedColorIndex,
      customColorValue: customColorValue ?? this.customColorValue,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'is24HourFormat': is24HourFormat,
      'brightness': brightness,
      'selectedWatchFace': selectedWatchFace,
      'selectedTimezone': selectedTimezone,
      'selectedColorIndex': selectedColorIndex,
      'customColorValue': customColorValue,
    };
  }

  /// Create from map
  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      is24HourFormat: map['is24HourFormat'] ?? true,
      brightness: (map['brightness'] ?? 1.0).toDouble(),
      selectedWatchFace: map['selectedWatchFace'] ?? 'led_white',
      selectedTimezone: map['selectedTimezone'] ?? 'auto',
      selectedColorIndex: map['selectedColorIndex'] ?? 0,
      customColorValue: map['customColorValue'],
    );
  }

  @override
  String toString() {
    return 'AppSettings(is24HourFormat: $is24HourFormat, brightness: $brightness, selectedWatchFace: $selectedWatchFace, selectedTimezone: $selectedTimezone, selectedColorIndex: $selectedColorIndex, customColorValue: $customColorValue)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppSettings &&
        other.is24HourFormat == is24HourFormat &&
        other.brightness == brightness &&
        other.selectedWatchFace == selectedWatchFace &&
        other.selectedTimezone == selectedTimezone &&
        other.selectedColorIndex == selectedColorIndex &&
        other.customColorValue == customColorValue;
  }

  @override
  int get hashCode {
    return is24HourFormat.hashCode ^
        brightness.hashCode ^
        selectedWatchFace.hashCode ^
        selectedTimezone.hashCode ^
        selectedColorIndex.hashCode ^
        customColorValue.hashCode;
  }
}
