import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../state/timer_provider.dart';
import '../widgets/timer_display.dart';
import '../widgets/app_button.dart';
import 'fullscreen_timer_screen.dart';

/// Timer screen with countdown and stopwatch functionality
class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Timer Display
                const TimerDisplay(fontSize: 72),

                const SizedBox(height: 40),

                // Fullscreen Timer Button
                AppButton(
                  label: 'Fullscreen Focus Timer',
                  icon: Icons.fullscreen,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FullscreenTimerScreen(),
                      ),
                    );
                  },
                  color: AppColors.accentNeon,
                  width: 240,
                ),

                const SizedBox(height: 24),

                // Control buttons
                Consumer<TimerProvider>(
                  builder: (context, timerProvider, child) {
                    return Column(
                      children: [
                        // Play/Pause and Reset buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppButton(
                              label: timerProvider.isRunning
                                  ? (timerProvider.isPaused
                                        ? 'Resume'
                                        : 'Pause')
                                  : 'Start',
                              icon: timerProvider.isRunning
                                  ? (timerProvider.isPaused
                                        ? Icons.play_arrow
                                        : Icons.pause)
                                  : Icons.play_arrow,
                              onPressed: () => timerProvider.togglePlayPause(),
                              color: AppColors.primaryNeon,
                              width: 140,
                            ),
                            const SizedBox(width: 16),
                            AppButton(
                              label: 'Reset',
                              icon: Icons.refresh,
                              onPressed: () => timerProvider.reset(),
                              color: AppColors.timerActive,
                              width: 140,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Mode switch and time adjustment
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Mode switch
                            AppButton(
                              label: timerProvider.isCountdown
                                  ? 'Countdown'
                                  : 'Stopwatch',
                              icon: timerProvider.isCountdown
                                  ? Icons.timer
                                  : Icons.timer_outlined,
                              onPressed: () => _showModeDialog(context),
                              isDisabled: timerProvider.isRunning,
                            ),
                            const SizedBox(width: 16),

                            // Time adjustment (only for countdown)
                            if (timerProvider.isCountdown)
                              AppButton(
                                label: 'Set Time',
                                icon: Icons.edit,
                                onPressed: timerProvider.isRunning
                                    ? null
                                    : () => _showTimePickerDialog(context),
                                isDisabled: timerProvider.isRunning,
                              ),
                          ],
                        ),

                        // Quick time buttons (only for countdown when not running)
                        if (timerProvider.isCountdown &&
                            !timerProvider.isRunning) ...[
                          const SizedBox(height: 24),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildQuickTimeButton(context, 1, '1 min'),
                              _buildQuickTimeButton(context, 5, '5 min'),
                              _buildQuickTimeButton(context, 10, '10 min'),
                              _buildQuickTimeButton(context, 15, '15 min'),
                              _buildQuickTimeButton(context, 30, '30 min'),
                              _buildQuickTimeButton(context, 60, '1 hour'),
                            ],
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build quick time button
  Widget _buildQuickTimeButton(
    BuildContext context,
    int minutes,
    String label,
  ) {
    return AppButton(
      label: label,
      onPressed: () {
        context.read<TimerProvider>().setMinutes(minutes);
      },
      width: 100,
      height: 40,
    );
  }

  /// Show mode selection dialog
  void _showModeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.buttonBackground,
        title: Text(
          'Select Mode',
          style: TextStyle(color: AppColors.primaryNeon),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.timer, color: AppColors.primaryNeon),
              title: Text(
                'Countdown Timer',
                style: TextStyle(color: AppColors.secondaryText),
              ),
              onTap: () {
                context.read<TimerProvider>().setMode(TimerMode.countdown);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.timer_outlined, color: AppColors.accentNeon),
              title: Text(
                'Stopwatch',
                style: TextStyle(color: AppColors.secondaryText),
              ),
              onTap: () {
                context.read<TimerProvider>().setMode(TimerMode.stopwatch);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Show time picker dialog for countdown
  void _showTimePickerDialog(BuildContext context) {
    int hours = 0;
    int minutes = 5;
    int seconds = 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppColors.buttonBackground,
          title: Text(
            'Set Countdown Time',
            style: TextStyle(color: AppColors.primaryNeon),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hours
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hours:',
                    style: TextStyle(color: AppColors.secondaryText),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, color: AppColors.primaryNeon),
                        onPressed: () {
                          if (hours > 0) setState(() => hours--);
                        },
                      ),
                      Text(
                        hours.toString().padLeft(2, '0'),
                        style: TextStyle(
                          color: AppColors.primaryNeon,
                          fontSize: 24,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: AppColors.primaryNeon),
                        onPressed: () {
                          if (hours < 23) setState(() => hours++);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              // Minutes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Minutes:',
                    style: TextStyle(color: AppColors.secondaryText),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, color: AppColors.primaryNeon),
                        onPressed: () {
                          if (minutes > 0) setState(() => minutes--);
                        },
                      ),
                      Text(
                        minutes.toString().padLeft(2, '0'),
                        style: TextStyle(
                          color: AppColors.primaryNeon,
                          fontSize: 24,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: AppColors.primaryNeon),
                        onPressed: () {
                          if (minutes < 59) setState(() => minutes++);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              // Seconds
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Seconds:',
                    style: TextStyle(color: AppColors.secondaryText),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, color: AppColors.primaryNeon),
                        onPressed: () {
                          if (seconds > 0) setState(() => seconds--);
                        },
                      ),
                      Text(
                        seconds.toString().padLeft(2, '0'),
                        style: TextStyle(
                          color: AppColors.primaryNeon,
                          fontSize: 24,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: AppColors.primaryNeon),
                        onPressed: () {
                          if (seconds < 59) setState(() => seconds++);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.secondaryText),
              ),
            ),
            TextButton(
              onPressed: () {
                final duration = Duration(
                  hours: hours,
                  minutes: minutes,
                  seconds: seconds,
                );
                if (duration.inSeconds > 0) {
                  context.read<TimerProvider>().setDuration(duration);
                }
                Navigator.pop(context);
              },
              child: Text(
                'Set',
                style: TextStyle(color: AppColors.primaryNeon),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
