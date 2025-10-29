import 'package:wakelock_plus/wakelock_plus.dart';

/// Service for managing wakelock (screen always-on)
class WakelockService {
  /// Enable wakelock to keep screen awake
  Future<void> enable() async {
    try {
      await WakelockPlus.enable();
    } catch (e) {
      // Handle error silently or log if needed
      print('Error enabling wakelock: $e');
    }
  }

  /// Disable wakelock to allow screen to sleep
  Future<void> disable() async {
    try {
      await WakelockPlus.disable();
    } catch (e) {
      // Handle error silently or log if needed
      print('Error disabling wakelock: $e');
    }
  }

  /// Check if wakelock is enabled
  Future<bool> isEnabled() async {
    try {
      return await WakelockPlus.enabled;
    } catch (e) {
      print('Error checking wakelock status: $e');
      return false;
    }
  }

  /// Toggle wakelock on/off
  Future<void> toggle() async {
    final enabled = await isEnabled();
    if (enabled) {
      await disable();
    } else {
      await enable();
    }
  }
}
