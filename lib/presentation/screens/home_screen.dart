import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import 'fullscreen_clock_screen.dart';
import 'fullscreen_timer_screen.dart';
import 'fullscreen_stopwatch_screen.dart';
import 'settings_screen.dart';
import 'alarm_screen.dart';
import 'remind_me_screen.dart';

/// Home screen with Clock and Timer options
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    top: 16.0,
                    bottom: isPortrait
                        ? 70.0
                        : 16.0, // Extra space for name in portrait
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // App title
                      Text(
                        'FOCUS CLOCK',
                        style: AppTextStyles.title(
                          fontSize: isPortrait ? 32 : 28,
                          color: AppColors.primaryNeon,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Choose your mode',
                        style: AppTextStyles.label(
                          fontSize: 13,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      SizedBox(height: isPortrait ? 50 : 40),

                      // Clock, Timer, and Stopwatch options - Layout based on orientation
                      isPortrait
                          ? Column(
                              children: [
                                // Clock option
                                _buildModeCard(
                                  context,
                                  icon: Icons.access_time,
                                  title: 'CLOCK',
                                  description: 'Fullscreen Display',
                                  color: AppColors.primaryNeon,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const FullscreenClockScreen(),
                                      ),
                                    );
                                  },
                                  isPortrait: true,
                                ),
                                const SizedBox(height: 16),
                                // Timer option
                                _buildModeCard(
                                  context,
                                  icon: Icons.timer,
                                  title: 'TIMER',
                                  description: 'Countdown',
                                  color: AppColors.accentNeon,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const FullscreenTimerScreen(),
                                      ),
                                    );
                                  },
                                  isPortrait: true,
                                ),
                                const SizedBox(height: 16),
                                // Stopwatch option
                                _buildModeCard(
                                  context,
                                  icon: Icons.av_timer,
                                  title: 'STOPWATCH',
                                  description: 'Count Up',
                                  color: const Color(0xff00ffaa),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const FullscreenStopwatchScreen(),
                                      ),
                                    );
                                  },
                                  isPortrait: true,
                                ),
                                const SizedBox(height: 16),
                                // Alarm option
                                _buildModeCard(
                                  context,
                                  icon: Icons.alarm,
                                  title: 'ALARM',
                                  description: 'Set Alarms',
                                  color: const Color(0xffff6b6b),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AlarmScreen(),
                                      ),
                                    );
                                  },
                                  isPortrait: true,
                                ),
                                const SizedBox(height: 16),
                                // Remind Me option (portrait only)
                                _buildModeCard(
                                  context,
                                  icon: Icons.notifications_active_rounded,
                                  title: 'REMIND ME',
                                  description: 'Set Reminders',
                                  color: const Color(0xffffaa00),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RemindMeScreen(),
                                      ),
                                    );
                                  },
                                  isPortrait: true,
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                // First row - Clock, Timer, Stopwatch, Alarm
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Clock option
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 4,
                                        ),
                                        child: _buildModeCard(
                                          context,
                                          icon: Icons.access_time,
                                          title: 'CLOCK',
                                          description: 'Fullscreen Display',
                                          color: AppColors.primaryNeon,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const FullscreenClockScreen(),
                                              ),
                                            );
                                          },
                                          isPortrait: false,
                                        ),
                                      ),
                                    ),
                                    // Timer option
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        child: _buildModeCard(
                                          context,
                                          icon: Icons.timer,
                                          title: 'TIMER',
                                          description: 'Countdown',
                                          color: AppColors.accentNeon,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const FullscreenTimerScreen(),
                                              ),
                                            );
                                          },
                                          isPortrait: false,
                                        ),
                                      ),
                                    ),
                                    // Stopwatch option
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        child: _buildModeCard(
                                          context,
                                          icon: Icons.av_timer,
                                          title: 'STOPWATCH',
                                          description: 'Count Up',
                                          color: const Color(0xff00ffaa),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const FullscreenStopwatchScreen(),
                                              ),
                                            );
                                          },
                                          isPortrait: false,
                                        ),
                                      ),
                                    ),
                                    // Alarm option
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: _buildModeCard(
                                          context,
                                          icon: Icons.alarm,
                                          title: 'ALARM',
                                          description: 'Set Alarms',
                                          color: const Color(0xffff6b6b),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const AlarmScreen(),
                                              ),
                                            );
                                          },
                                          isPortrait: false,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Second row for landscape - Remind Me
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 60,
                                        ),
                                        child: _buildModeCard(
                                          context,
                                          icon: Icons
                                              .notifications_active_rounded,
                                          title: 'REMIND ME',
                                          description: 'Set Reminders',
                                          color: const Color(0xffffaa00),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const RemindMeScreen(),
                                              ),
                                            );
                                          },
                                          isPortrait: false,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),

            // Credit section at bottom
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    'Built By',
                    style: AppTextStyles.label(
                      fontSize: 11,
                      color: AppColors.secondaryText.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () async {
                      final Uri url = Uri.parse(
                        'https://github.com/mehedi-hridoy',
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                    child: Text(
                      'Mehedi Hasan Hridoy',
                      style: AppTextStyles.label(
                        fontSize: 13,
                        color: AppColors.primaryNeon,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Settings button in top right
            Positioned(
              top: 12,
              right: 12,
              child: IconButton(
                icon: Icon(
                  Icons.settings,
                  color: AppColors.secondaryText,
                  size: 26,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
    required bool isPortrait,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: isPortrait
            ? const BoxConstraints(maxHeight: 120, minHeight: 100)
            : const BoxConstraints(maxHeight: 180, minHeight: 160),
        decoration: BoxDecoration(
          color: AppColors.buttonBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: isPortrait
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 20),
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 36, color: color),
                  ),
                  const SizedBox(width: 20),
                  // Title and Description
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.buttonText(
                            fontSize: 18,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: AppTextStyles.label(
                            fontSize: 11,
                            color: AppColors.secondaryText.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 40, color: color),
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    title,
                    style: AppTextStyles.buttonText(fontSize: 16, color: color),
                  ),
                  const SizedBox(height: 4),
                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      description,
                      style: AppTextStyles.label(
                        fontSize: 10,
                        color: AppColors.secondaryText.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
