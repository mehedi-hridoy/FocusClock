import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../state/timer_provider.dart';

/// Timer display widget with progress indicator
class TimerDisplay extends StatelessWidget {
  final double fontSize;
  final Color? color;
  final bool showProgress;

  const TimerDisplay({
    super.key,
    this.fontSize = 72,
    this.color,
    this.showProgress = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, timerProvider, child) {
        final displayColor = timerProvider.isFinished
            ? AppColors.timerActive
            : (color ?? AppColors.accentNeon);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Mode indicator
            Text(
              timerProvider.isCountdown ? 'COUNTDOWN' : 'STOPWATCH',
              style: AppTextStyles.label(
                fontSize: fontSize * 0.2,
                color: AppColors.secondaryText,
              ),
            ),

            const SizedBox(height: 16),

            // Timer display
            Text(
                  timerProvider.timeString,
                  style: AppTextStyles.timerDisplay(
                    fontSize: fontSize,
                    color: displayColor,
                  ),
                )
                .animate(
                  onPlay: (controller) =>
                      timerProvider.isRunning && !timerProvider.isPaused
                      ? controller.repeat()
                      : null,
                )
                .fadeIn(duration: 300.ms)
                .scale(
                  begin: const Offset(0.98, 0.98),
                  end: const Offset(1.0, 1.0),
                  duration: 1000.ms,
                ),

            const SizedBox(height: 24),

            // Progress bar for countdown mode
            if (showProgress && timerProvider.isCountdown)
              SizedBox(
                width: 400,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: timerProvider.progress,
                        minHeight: 8,
                        backgroundColor: AppColors.buttonBackground,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          timerProvider.isFinished
                              ? AppColors.timerActive
                              : AppColors.accentNeon,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(timerProvider.progress * 100).toStringAsFixed(0)}%',
                      style: AppTextStyles.label(
                        fontSize: fontSize * 0.15,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),

            // Status text
            if (timerProvider.isRunning)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child:
                    Text(
                          timerProvider.isPaused ? 'PAUSED' : 'RUNNING',
                          style: AppTextStyles.label(
                            fontSize: fontSize * 0.18,
                            color: timerProvider.isPaused
                                ? AppColors.secondaryText
                                : AppColors.primaryNeon,
                          ),
                        )
                        .animate(
                          onPlay: (controller) => timerProvider.isPaused
                              ? null
                              : controller.repeat(),
                        )
                        .fadeIn(duration: 500.ms)
                        .then()
                        .fadeOut(duration: 500.ms),
              ),
          ],
        );
      },
    );
  }
}
