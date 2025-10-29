import 'dart:async';
import 'package:flutter/material.dart';
import '../core/utils/time_utils.dart';
import '../core/services/alarm_service.dart';

/// Enum for timer mode
enum TimerMode { countdown, stopwatch }

/// Provider for managing timer/stopwatch state
class TimerProvider extends ChangeNotifier {
  Timer? _timer;
  Duration _duration = const Duration(
    minutes: 5,
  ); // Default 5 minutes for countdown
  Duration _elapsed = Duration.zero;
  TimerMode _mode = TimerMode.countdown;
  bool _isRunning = false;
  bool _isPaused = false;
  bool _isReverseCountdown =
      true; // true = count down (60->0), false = count up (0->60)
  final AlarmService _alarmService = AlarmService();

  // Getters
  Duration get duration => _duration;
  Duration get elapsed => _elapsed;
  TimerMode get mode => _mode;
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;
  bool get isCountdown => _mode == TimerMode.countdown;
  bool get isStopwatch => _mode == TimerMode.stopwatch;
  bool get isReverseCountdown => _isReverseCountdown;

  /// Get formatted time string
  String get timeString {
    if (_mode == TimerMode.countdown) {
      final remaining = _duration - _elapsed;
      return TimeUtils.formatDuration(remaining);
    } else {
      return TimeUtils.formatDuration(_elapsed);
    }
  }

  /// Get progress (0.0 to 1.0) for countdown mode
  double get progress {
    if (_mode == TimerMode.countdown && _duration.inSeconds > 0) {
      return (_elapsed.inSeconds / _duration.inSeconds).clamp(0.0, 1.0);
    }
    return 0.0;
  }

  /// Check if countdown is finished
  bool get isFinished {
    return _mode == TimerMode.countdown && _elapsed >= _duration;
  }

  /// Set timer mode
  void setMode(TimerMode mode) {
    if (_mode != mode) {
      _mode = mode;
      reset();
      notifyListeners();
    }
  }

  /// Toggle countdown direction (reverse: 60->0, forward: 0->60)
  void toggleCountdownDirection() {
    if (!_isRunning) {
      _isReverseCountdown = !_isReverseCountdown;
      notifyListeners();
    }
  }

  /// Set countdown direction
  void setCountdownDirection(bool isReverse) {
    if (!_isRunning) {
      _isReverseCountdown = isReverse;
      notifyListeners();
    }
  }

  /// Set countdown duration
  void setDuration(Duration duration) {
    if (!_isRunning) {
      _duration = duration;
      _elapsed = Duration.zero;
      notifyListeners();
    }
  }

  /// Start the timer
  void start() {
    if (!_isRunning) {
      _isRunning = true;
      _isPaused = false;
      _startTimer();
      notifyListeners();
    }
  }

  /// Pause the timer
  void pause() {
    if (_isRunning && !_isPaused) {
      _isPaused = true;
      _timer?.cancel();
      notifyListeners();
    }
  }

  /// Resume the timer
  void resume() {
    if (_isRunning && _isPaused) {
      _isPaused = false;
      _startTimer();
      notifyListeners();
    }
  }

  /// Toggle play/pause
  void togglePlayPause() {
    if (!_isRunning) {
      start();
    } else if (_isPaused) {
      resume();
    } else {
      pause();
    }
  }

  /// Reset the timer
  void reset() {
    _timer?.cancel();
    _isRunning = false;
    _isPaused = false;
    _elapsed = Duration.zero;
    _alarmService.stopAlarm(); // Stop alarm when resetting
    notifyListeners();
  }

  /// Stop the timer (same as reset but keeps mode)
  void stop() {
    reset();
  }

  /// Internal method to start the timer
  void _startTimer() {
    _timer?.cancel();

    // Use different intervals for countdown vs stopwatch
    final interval = _mode == TimerMode.stopwatch
        ? const Duration(
            milliseconds: 100,
          ) // 100ms precision for stopwatch (smoother rendering)
        : const Duration(seconds: 1); // 1s precision for countdown

    _timer = Timer.periodic(interval, (timer) {
      if (_mode == TimerMode.countdown) {
        if (_elapsed < _duration) {
          _elapsed += const Duration(seconds: 1);
          notifyListeners();

          // Check if countdown reached zero
          if (_elapsed >= _duration) {
            // Stop the timer but keep the finished state
            _timer?.cancel();
            _isRunning = false;
            _isPaused = false;
            notifyListeners();

            // Play alarm when timer finishes
            _alarmService.playAlarm();
          }
        }
      } else {
        // Stopwatch mode - increment by 100ms for smooth but stable display
        _elapsed += const Duration(milliseconds: 100);
        notifyListeners();
      }
    });
  }

  /// Add time to countdown (in minutes)
  void addMinutes(int minutes) {
    if (!_isRunning) {
      _duration += Duration(minutes: minutes);
      notifyListeners();
    }
  }

  /// Subtract time from countdown (in minutes)
  void subtractMinutes(int minutes) {
    if (!_isRunning) {
      final newDuration = _duration - Duration(minutes: minutes);
      if (newDuration.inSeconds > 0) {
        _duration = newDuration;
        notifyListeners();
      }
    }
  }

  /// Set countdown duration in minutes
  void setMinutes(int minutes) {
    if (!_isRunning) {
      _duration = Duration(minutes: minutes);
      _elapsed = Duration.zero;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _alarmService.stopAlarm();
    super.dispose();
  }
}
