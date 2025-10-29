import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../state/alarm_provider.dart';
import '../../state/settings_provider.dart';
import '../../core/constants/color_palette.dart';

/// Dialog shown when an alarm is ringing
class AlarmRingingDialog extends StatelessWidget {
  const AlarmRingingDialog({super.key});

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
              color: primaryColor.withOpacity(0.98),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Alarm icon
                    Icon(Icons.alarm, size: 100, color: Colors.white),
                    const SizedBox(height: 24),

                    // Time
                    Text(
                      alarm.getFormattedTime(),
                      style: GoogleFonts.comfortaa(
                        fontSize: 64,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Label
                    if (alarm.label.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          alarm.label,
                          style: GoogleFonts.comfortaa(
                            fontSize: 24,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    const SizedBox(height: 60),

                    // Snooze button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            alarmProvider.snoozeAlarm();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.3),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Text(
                            'Snooze (10 min)',
                            style: GoogleFonts.comfortaa(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Stop button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            alarmProvider.stopAlarm();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 64,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 8,
                          ),
                          child: Text(
                            'STOP',
                            style: GoogleFonts.comfortaa(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
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
