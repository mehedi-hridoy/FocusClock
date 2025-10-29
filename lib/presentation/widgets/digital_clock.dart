import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../state/clock_provider.dart';

/// Digital clock widget with neon glow effect
class DigitalClock extends StatelessWidget {
  final double fontSize;
  final Color? color;

  const DigitalClock({super.key, this.fontSize = 80, this.color});

  @override
  Widget build(BuildContext context) {
    return Consumer<ClockProvider>(
      builder: (context, clockProvider, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Time display
            Text(
                  clockProvider.currentTimeString,
                  style: AppTextStyles.digitalClock(
                    fontSize: fontSize,
                    color: color ?? AppColors.primaryNeon,
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(
                  duration: 2000.ms,
                  color:
                      color?.withOpacity(0.3) ??
                      AppColors.primaryNeon.withOpacity(0.3),
                ),

            const SizedBox(height: 8),

            // Date display
            Text(
              clockProvider.currentDateString,
              style: AppTextStyles.robotoMono(
                fontSize: fontSize * 0.18,
                color: AppColors.secondaryText,
              ),
            ),

            const SizedBox(height: 4),

            // Timezone display
            Text(
              '${clockProvider.getTimezoneDisplayName()} (${clockProvider.timezoneOffsetString})',
              style: AppTextStyles.label(
                fontSize: fontSize * 0.15,
                color: AppColors.secondaryText.withOpacity(0.7),
              ),
            ),
          ],
        );
      },
    );
  }
}
