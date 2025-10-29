import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/color_palette.dart';
import '../../state/timer_provider.dart';
import '../../state/settings_provider.dart';
import '../../core/services/alarm_service.dart';
import '../widgets/custom_color_picker.dart';

/// Fullscreen minimal timer display
class FullscreenTimerScreen extends StatefulWidget {
  const FullscreenTimerScreen({super.key});

  @override
  State<FullscreenTimerScreen> createState() => _FullscreenTimerScreenState();
}

class _FullscreenTimerScreenState extends State<FullscreenTimerScreen>
    with SingleTickerProviderStateMixin {
  bool _showTimerInput = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Set default timer to 25 minutes if not already set
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final timerProvider = Provider.of<TimerProvider>(context, listen: false);
      if (!timerProvider.isRunning && timerProvider.duration.inMinutes == 5) {
        timerProvider.setMinutes(25);
      }
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (hours > 0) {
      return '${twoDigits(hours)}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  Map<String, String> _formatTimeDigits(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return {
      'hasHours': hours > 0 ? 'true' : 'false',
      'hours': twoDigits(hours),
      'minutes': minutes,
      'seconds': seconds,
    };
  }

  // Helper to build digit with FIXED WIDTH (solid style for timer)
  Widget _buildTimerDigit(String digit, Color color, bool isPortrait) {
    return SizedBox(
      width: isPortrait ? 50.0 : 110.0, // Fixed width for each digit
      child: Center(
        child: Text(
          digit,
          style: GoogleFonts.comfortaa(
            fontSize: isPortrait ? 90.0 : 200.0,
            color: color,
            fontWeight: FontWeight.w900,
            height: 1.0,
          ),
        ),
      ),
    );
  }

  // Helper to build colon separator
  Widget _buildTimerColon(Color color, bool isPortrait) {
    return SizedBox(
      width: isPortrait ? 25.0 : 50.0, // Fixed width for colon
      child: Center(
        child: Text(
          ':',
          style: GoogleFonts.comfortaa(
            fontSize: isPortrait ? 90.0 : 200.0,
            color: color,
            fontWeight: FontWeight.w900,
            height: 1.0,
          ),
        ),
      ),
    );
  }

  Duration _getRemainingTime(TimerProvider timerProvider) {
    if (timerProvider.isCountdown) {
      return timerProvider.duration - timerProvider.elapsed;
    }
    return timerProvider.elapsed;
  }

  void _toggleTimerInput() {
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);

    setState(() {
      _showTimerInput = !_showTimerInput;
      if (_showTimerInput) {
        // Pre-fill with current duration
        final currentMinutes = timerProvider.duration.inMinutes;
        final currentSeconds = timerProvider.duration.inSeconds.remainder(60);
        _minutesController.text = currentMinutes.toString();
        _secondsController.text = currentSeconds.toString().padLeft(2, '0');
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _setCustomTime() {
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;

    if (minutes > 0 || seconds > 0) {
      final timerProvider = Provider.of<TimerProvider>(context, listen: false);
      final totalSeconds = (minutes * 60) + seconds;

      // Clamp to reasonable limits (1 second to 24 hours)
      final clampedSeconds = totalSeconds.clamp(1, 86400);

      timerProvider.setDuration(Duration(seconds: clampedSeconds));
      _toggleTimerInput();
    }
  }

  void _incrementMinutes() {
    final current = int.tryParse(_minutesController.text) ?? 0;
    _minutesController.text = (current + 1).clamp(0, 1440).toString();
  }

  void _decrementMinutes() {
    final current = int.tryParse(_minutesController.text) ?? 0;
    _minutesController.text = (current - 1).clamp(0, 1440).toString();
  }

  void _incrementSeconds() {
    final current = int.tryParse(_secondsController.text) ?? 0;
    _secondsController.text = ((current + 1).clamp(
      0,
      59,
    )).toString().padLeft(2, '0');
  }

  void _decrementSeconds() {
    final current = int.tryParse(_secondsController.text) ?? 0;
    _secondsController.text = ((current - 1).clamp(
      0,
      59,
    )).toString().padLeft(2, '0');
  }

  void _cycleColor(bool forward) {
    final settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );
    final currentIndex = settingsProvider.selectedColorIndex;
    final totalColors = ColorPalette.colors.length;

    int newIndex;
    if (forward) {
      newIndex = (currentIndex + 1) % totalColors;
    } else {
      newIndex = (currentIndex - 1 + totalColors) % totalColors;
    }

    settingsProvider.setSelectedColorIndex(newIndex);
  }

  void _adjustTime(bool increase) {
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);

    // Don't adjust if timer is running
    if (timerProvider.isRunning) return;

    final currentMinutes = timerProvider.duration.inMinutes;
    int newMinutes;

    if (increase) {
      // Increase by 5 minutes, max 120 minutes (2 hours)
      newMinutes = (currentMinutes + 5).clamp(1, 120);
    } else {
      // Decrease by 5 minutes, min 1 minute
      newMinutes = (currentMinutes - 5).clamp(1, 120);
    }

    if (newMinutes != currentMinutes) {
      timerProvider.setMinutes(newMinutes);
    }
  }

  Widget _buildCircularTimerPortrait(
    TimerProvider timerProvider,
    Color displayColor,
    Duration remainingTime,
    String timeString,
  ) {
    final progress = timerProvider.duration.inSeconds > 0
        ? remainingTime.inSeconds / timerProvider.duration.inSeconds
        : 0.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        // Circular progress with time
        SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.withOpacity(0.1),
                ),
              ),
              // Progress circle
              SizedBox(
                width: 280,
                height: 280,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 12,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(displayColor),
                ),
              ),
              // Time display in center
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    timeString,
                    style: GoogleFonts.comfortaa(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: displayColor,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        // Quick adjust buttons
        if (!timerProvider.isRunning || timerProvider.isPaused)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildQuickAdjustButton('-10s', displayColor, () {
                final newDuration =
                    timerProvider.duration - const Duration(seconds: 10);
                if (newDuration.inSeconds > 0) {
                  timerProvider.setDuration(newDuration);
                }
              }),
              const SizedBox(width: 20),
              _buildQuickAdjustButton('+30s', displayColor, () {
                final newDuration =
                    timerProvider.duration + const Duration(seconds: 30);
                timerProvider.setDuration(newDuration);
              }),
            ],
          ),
        const SizedBox(height: 60),
        // Control buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Stop button
            GestureDetector(
              onTap: () => timerProvider.reset(),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: const Icon(Icons.stop, color: Colors.red, size: 32),
              ),
            ),
            const SizedBox(width: 30),
            // Play/Pause button
            GestureDetector(
              onTap: () => timerProvider.togglePlayPause(),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: displayColor.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: displayColor, width: 3),
                ),
                child: Icon(
                  timerProvider.isRunning && !timerProvider.isPaused
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: displayColor,
                  size: 36,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAdjustButton(
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Text(
          label,
          style: GoogleFonts.comfortaa(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer2<TimerProvider, SettingsProvider>(
        builder: (context, timerProvider, settingsProvider, child) {
          final selectedColor = ColorPalette.getColor(
            settingsProvider.selectedColorIndex,
          );
          final displayColor = Color.lerp(
            selectedColor.withOpacity(0.15),
            selectedColor,
            settingsProvider.brightness,
          )!;

          final remainingTime = _getRemainingTime(timerProvider);
          final timeString = _formatTime(remainingTime);
          final timeDigits = _formatTimeDigits(remainingTime);
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;

          return GestureDetector(
            onDoubleTap: () {
              // Show timer input on double tap (only if alarm is not ringing)
              if (!timerProvider.isFinished) {
                _toggleTimerInput();
              }
            },
            onVerticalDragEnd: (details) {
              if (_showTimerInput) return;

              if (details.primaryVelocity != null) {
                if (details.primaryVelocity! < -500) {
                  _cycleColor(true);
                } else if (details.primaryVelocity! > 500) {
                  _cycleColor(false);
                }
              }
            },
            onHorizontalDragEnd: (details) {
              if (_showTimerInput) return;

              // Swipe left/right to adjust timer duration
              if (details.primaryVelocity != null) {
                if (details.primaryVelocity! > 500) {
                  // Swiped right - increase time
                  _adjustTime(true);
                } else if (details.primaryVelocity! < -500) {
                  // Swiped left - decrease time
                  _adjustTime(false);
                }
              }
            },
            onLongPress: () {
              if (!_showTimerInput) {
                Navigator.pop(context);
              }
            },
            child: Stack(
              children: [
                // Main Timer Display
                Center(
                  child: isPortrait
                      ? _buildCircularTimerPortrait(
                          timerProvider,
                          displayColor,
                          remainingTime,
                          timeString,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Fixed-width digit display for landscape
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Hours (if > 0)
                                if (timeDigits['hasHours'] == 'true') ...[
                                  _buildTimerDigit(
                                    timeDigits['hours']![0],
                                    displayColor,
                                    isPortrait,
                                  ),
                                  _buildTimerDigit(
                                    timeDigits['hours']![1],
                                    displayColor,
                                    isPortrait,
                                  ),
                                  _buildTimerColon(displayColor, isPortrait),
                                ],
                                // Minutes - First digit
                                _buildTimerDigit(
                                  timeDigits['minutes']![0],
                                  displayColor,
                                  isPortrait,
                                ),
                                // Minutes - Second digit
                                _buildTimerDigit(
                                  timeDigits['minutes']![1],
                                  displayColor,
                                  isPortrait,
                                ),
                                // Colon separator
                                _buildTimerColon(displayColor, isPortrait),
                                // Seconds - First digit
                                _buildTimerDigit(
                                  timeDigits['seconds']![0],
                                  displayColor,
                                  isPortrait,
                                ),
                                // Seconds - Second digit
                                _buildTimerDigit(
                                  timeDigits['seconds']![1],
                                  displayColor,
                                  isPortrait,
                                ),
                              ],
                            ),
                          ],
                        ),
                ),

                // Bottom Control Buttons (shown when NOT finished and in landscape)
                if (!timerProvider.isFinished && !isPortrait)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Play/Pause Button
                        GestureDetector(
                          onTap: () => timerProvider.togglePlayPause(),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: displayColor.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: displayColor.withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              timerProvider.isRunning && !timerProvider.isPaused
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: displayColor,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Reset Button
                        GestureDetector(
                          onTap: () => timerProvider.reset(),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: displayColor.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: displayColor.withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.refresh,
                              color: displayColor,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Alarm Popup Overlay (shown when finished)
                if (timerProvider.isFinished)
                  Container(
                    color: Colors.black.withOpacity(0.95),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 500),
                          margin: const EdgeInsets.all(24),
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: const Color(0xff0a0a0a),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: displayColor, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: displayColor.withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Alarm Icon with Pulse Effect
                              TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 0.8, end: 1.2),
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.easeInOut,
                                builder: (context, scale, child) {
                                  return Transform.scale(
                                    scale: scale,
                                    child: Icon(
                                      Icons.notifications_active_rounded,
                                      size: 80,
                                      color: displayColor,
                                    ),
                                  );
                                },
                                onEnd: () {
                                  // Restart animation
                                  setState(() {});
                                },
                              ),
                              const SizedBox(height: 24),

                              // "TIME'S UP" Title
                              Text(
                                "TIME'S UP!",
                                style: GoogleFonts.comfortaa(
                                  fontSize: 36,
                                  color: displayColor,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 4.0,
                                ),
                              ),
                              const SizedBox(height: 28),

                              // Action Buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // STOP Button
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        AlarmService().stopAlarm();
                                        timerProvider.reset();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: displayColor,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.stop_circle_rounded,
                                              color: Colors.black,
                                              size: 32,
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              'STOP',
                                              style: GoogleFonts.comfortaa(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 2.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),

                                  // SNOOZE Button
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        AlarmService().stopAlarm();
                                        timerProvider.setMinutes(5);
                                        timerProvider.start();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: displayColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: displayColor,
                                            width: 2,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.snooze_rounded,
                                              color: displayColor,
                                              size: 32,
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              'SNOOZE',
                                              style: GoogleFonts.comfortaa(
                                                fontSize: 16,
                                                color: displayColor,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 2.0,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '5 MIN',
                                              style: GoogleFonts.comfortaa(
                                                fontSize: 11,
                                                color: displayColor.withOpacity(
                                                  0.7,
                                                ),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                // Custom Timer Input Overlay with Color Picker
                if (_showTimerInput)
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: GestureDetector(
                      onTap: () => _toggleTimerInput(),
                      child: Container(
                        color: Colors.black.withOpacity(0.9),
                        child: Center(
                          child: SingleChildScrollView(
                            child: GestureDetector(
                              onTap:
                                  () {}, // Prevent closing when tapping inside
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Timer Input Section
                                    Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 450,
                                      ),
                                      padding: const EdgeInsets.all(28),
                                      decoration: BoxDecoration(
                                        color: const Color(0xff0a0a0a),
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: displayColor.withOpacity(0.5),
                                          width: 2,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Title with close button
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'SET TIMER',
                                                style: GoogleFonts.comfortaa(
                                                  fontSize: 20,
                                                  color: displayColor,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 2.5,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: _toggleTimerInput,
                                                child: Icon(
                                                  Icons.close,
                                                  color: displayColor
                                                      .withOpacity(0.7),
                                                  size: 24,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 28),

                                          // Quick Preset Buttons
                                          Text(
                                            'QUICK PRESETS',
                                            style: GoogleFonts.comfortaa(
                                              fontSize: 12,
                                              color: displayColor.withOpacity(
                                                0.6,
                                              ),
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 2.0,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Wrap(
                                            spacing: 10,
                                            runSpacing: 10,
                                            alignment: WrapAlignment.center,
                                            children: [
                                              _buildPresetButton(
                                                '5',
                                                5,
                                                displayColor,
                                              ),
                                              _buildPresetButton(
                                                '10',
                                                10,
                                                displayColor,
                                              ),
                                              _buildPresetButton(
                                                '15',
                                                15,
                                                displayColor,
                                              ),
                                              _buildPresetButton(
                                                '20',
                                                20,
                                                displayColor,
                                              ),
                                              _buildPresetButton(
                                                '25',
                                                25,
                                                displayColor,
                                              ),
                                              _buildPresetButton(
                                                '30',
                                                30,
                                                displayColor,
                                              ),
                                              _buildPresetButton(
                                                '45',
                                                45,
                                                displayColor,
                                              ),
                                              _buildPresetButton(
                                                '60',
                                                60,
                                                displayColor,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 28),

                                          // Custom Time Input
                                          Text(
                                            'CUSTOM TIME',
                                            style: GoogleFonts.comfortaa(
                                              fontSize: 12,
                                              color: displayColor.withOpacity(
                                                0.6,
                                              ),
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 2.0,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // Minutes Column
                                              _buildTimeInput(
                                                controller: _minutesController,
                                                label: 'MIN',
                                                onIncrement: _incrementMinutes,
                                                onDecrement: _decrementMinutes,
                                                displayColor: displayColor,
                                              ),
                                              // Separator
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                    ),
                                                child: Text(
                                                  ':',
                                                  style: GoogleFonts.comfortaa(
                                                    fontSize: 40,
                                                    color: displayColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              // Seconds Column
                                              _buildTimeInput(
                                                controller: _secondsController,
                                                label: 'SEC',
                                                onIncrement: _incrementSeconds,
                                                onDecrement: _decrementSeconds,
                                                displayColor: displayColor,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 24),

                                          // Set Button
                                          GestureDetector(
                                            onTap: _setCustomTime,
                                            child: Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: displayColor,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: displayColor
                                                        .withOpacity(0.3),
                                                    blurRadius: 12,
                                                    spreadRadius: 2,
                                                  ),
                                                ],
                                              ),
                                              child: Text(
                                                'START TIMER',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.comfortaa(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 2.5,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Color Picker Section Below
                                    Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 400,
                                      ),
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: displayColor.withOpacity(0.5),
                                          width: 2,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Choose Color',
                                            style: GoogleFonts.comfortaa(
                                              fontSize: 18,
                                              color: displayColor,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2.0,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          GridView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 6,
                                                  crossAxisSpacing: 12,
                                                  mainAxisSpacing: 12,
                                                  childAspectRatio: 1,
                                                ),
                                            itemCount:
                                                ColorPalette.colors.length,
                                            itemBuilder: (context, index) {
                                              final color =
                                                  ColorPalette.colors[index];
                                              final isSelected =
                                                  index ==
                                                  settingsProvider
                                                      .selectedColorIndex;

                                              return GestureDetector(
                                                onTap: () {
                                                  settingsProvider
                                                      .setSelectedColorIndex(
                                                        index,
                                                      );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: color,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    border: Border.all(
                                                      color: isSelected
                                                          ? Colors.white
                                                          : Colors.white
                                                                .withOpacity(
                                                                  0.2,
                                                                ),
                                                      width: isSelected ? 3 : 1,
                                                    ),
                                                    boxShadow: isSelected
                                                        ? [
                                                            BoxShadow(
                                                              color: color
                                                                  .withOpacity(
                                                                    0.5,
                                                                  ),
                                                              blurRadius: 8,
                                                              spreadRadius: 1,
                                                            ),
                                                          ]
                                                        : null,
                                                  ),
                                                  child: isSelected
                                                      ? const Icon(
                                                          Icons.check,
                                                          color: Colors.black,
                                                          size: 20,
                                                        )
                                                      : null,
                                                ),
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 16),

                                          // Custom Color Button
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton.icon(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                await showDialog<bool>(
                                                  context: context,
                                                  builder: (context) => Dialog(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child: CustomColorPicker(
                                                      initialColor:
                                                          settingsProvider
                                                              .getActiveColor(),
                                                      onColorChanged:
                                                          (color) {},
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.black
                                                    .withOpacity(0.3),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 14,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  side: BorderSide(
                                                    color: displayColor
                                                        .withOpacity(0.5),
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                              icon: Icon(
                                                Icons.colorize_rounded,
                                                color: displayColor,
                                              ),
                                              label: Text(
                                                'CUSTOM COLOR (RGB)',
                                                style: GoogleFonts.comfortaa(
                                                  fontSize: 12,
                                                  color: displayColor,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build preset button for quick timer selection
  Widget _buildPresetButton(String label, int minutes, Color color) {
    return GestureDetector(
      onTap: () {
        _minutesController.text = minutes.toString();
        _secondsController.text = '00';
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.4), width: 1.5),
        ),
        child: Text(
          '$label min',
          style: GoogleFonts.comfortaa(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  /// Build time input field with increment/decrement buttons
  Widget _buildTimeInput({
    required TextEditingController controller,
    required String label,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    required Color displayColor,
  }) {
    return Column(
      children: [
        // Increment button
        GestureDetector(
          onTap: onIncrement,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: displayColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.add, color: displayColor, size: 24),
          ),
        ),
        const SizedBox(height: 12),
        // Time Input
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: displayColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: displayColor.withOpacity(0.3), width: 2),
          ),
          child: Center(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: GoogleFonts.comfortaa(
                fontSize: 32,
                color: displayColor,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: '00',
                hintStyle: GoogleFonts.comfortaa(
                  fontSize: 32,
                  color: displayColor.withOpacity(0.3),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Decrement button
        GestureDetector(
          onTap: onDecrement,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: displayColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.remove, color: displayColor, size: 24),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.comfortaa(
            fontSize: 10,
            color: displayColor.withOpacity(0.6),
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}
