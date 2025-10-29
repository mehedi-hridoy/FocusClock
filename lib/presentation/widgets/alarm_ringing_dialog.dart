import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../state/alarm_provider.dart';
import '../../state/settings_provider.dart';
import '../../core/constants/color_palette.dart';

/// Dialog shown when an alarm is ringing
class AlarmRingingDialog extends StatefulWidget {
  const AlarmRingingDialog({super.key});

  @override
  State<AlarmRingingDialog> createState() => _AlarmRingingDialogState();
}

class _AlarmRingingDialogState extends State<AlarmRingingDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AlarmProvider, SettingsProvider>(
      builder: (context, alarmProvider, settingsProvider, child) {
        final alarm = alarmProvider.ringingAlarm;
        if (alarm == null) {
          // If alarm stopped, close dialog
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          });
          return const SizedBox.shrink();
        }

        final primaryColor = ColorPalette.getColor(
          settingsProvider.selectedColorIndex,
        );

        return PopScope(
          canPop: false, // Prevent back button dismiss
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    primaryColor.withOpacity(0.3),
                    Colors.black,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),

                    // Animated alarm icon with pulse effect
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + (_animationController.value * 0.2),
                          child: Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor.withOpacity(0.2),
                              border: Border.all(color: primaryColor, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.5),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.alarm,
                              size: 80,
                              color: primaryColor,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 40),

                    // "Alarm" text
                    Text(
                      'ALARM',
                      style: GoogleFonts.comfortaa(
                        fontSize: 28,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Time - Large and bold
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        alarm.getFormattedTime(),
                        style: GoogleFonts.orbitron(
                          fontSize: 72,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(color: primaryColor, blurRadius: 20),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Label - If exists
                    if (alarm.label.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          alarm.label,
                          style: GoogleFonts.comfortaa(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    const Spacer(),

                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          // Stop button - Primary action
                          SizedBox(
                            width: double.infinity,
                            height: 65,
                            child: ElevatedButton(
                              onPressed: () {
                                alarmProvider.stopAlarm();
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 10,
                                shadowColor: primaryColor.withOpacity(0.5),
                              ),
                              child: Text(
                                'STOP',
                                style: GoogleFonts.comfortaa(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 3,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Snooze button - Secondary action
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: OutlinedButton(
                              onPressed: () {
                                alarmProvider.snoozeAlarm();
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: BorderSide(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.snooze,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Snooze (10 min)',
                                    style: GoogleFonts.comfortaa(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
