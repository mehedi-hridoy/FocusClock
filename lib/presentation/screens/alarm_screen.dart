import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../state/alarm_provider.dart';
import '../../state/settings_provider.dart';
import 'add_alarm_screen.dart';
import '../widgets/alarm_ringing_dialog.dart';

/// Alarm list screen showing all alarms
class AlarmScreen extends StatelessWidget {
  const AlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AlarmProvider, SettingsProvider>(
      builder: (context, alarmProvider, settingsProvider, child) {
        final alarms = alarmProvider.alarms;
        final backgroundColor = Colors.black; // Changed to solid black

        final primaryColor = settingsProvider.getActiveColor();

        // Show alarm ringing dialog if there's a ringing alarm
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (alarmProvider.hasRingingAlarm) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const AlarmRingingDialog(),
            );
          }
        });

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: primaryColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Alarm',
              style: GoogleFonts.comfortaa(
                fontSize: 24,
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.more_vert, color: primaryColor),
                onPressed: () {
                  // Show options menu
                },
              ),
            ],
          ),
          body: alarms.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.alarm_off,
                        size: 80,
                        color: primaryColor.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No alarms set',
                        style: GoogleFonts.comfortaa(
                          fontSize: 18,
                          color: primaryColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: alarms.length,
                  itemBuilder: (context, index) {
                    final alarm = alarms[index];
                    return _buildAlarmCard(
                      context,
                      alarm,
                      alarmProvider,
                      primaryColor,
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddAlarmScreen()),
              );
            },
            backgroundColor: primaryColor,
            elevation: 8,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.3),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 32),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlarmCard(
    BuildContext context,
    alarm,
    AlarmProvider alarmProvider,
    Color primaryColor,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: alarm.isEnabled
            ? primaryColor.withOpacity(0.15)
            : const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: alarm.isEnabled
              ? primaryColor.withOpacity(0.5)
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddAlarmScreen(alarm: alarm),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Time and label
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Time
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            alarm.getFormattedTime().split(' ')[0], // Time part
                            style: GoogleFonts.comfortaa(
                              fontSize: 42,
                              color: alarm.isEnabled
                                  ? primaryColor
                                  : Colors.grey,
                              fontWeight: FontWeight.w400,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            alarm.getFormattedTime().split(' ')[1], // am/pm
                            style: GoogleFonts.comfortaa(
                              fontSize: 16,
                              color: alarm.isEnabled
                                  ? primaryColor.withOpacity(0.7)
                                  : Colors.grey.withOpacity(0.7),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Label or repeat info
                      Text(
                        alarm.label.isNotEmpty
                            ? alarm.label
                            : alarm.getRepeatDaysString(),
                        style: GoogleFonts.comfortaa(
                          fontSize: 13,
                          color: alarm.isEnabled
                              ? primaryColor.withOpacity(0.5)
                              : Colors.grey.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                // Toggle switch
                Switch(
                  value: alarm.isEnabled,
                  onChanged: (value) {
                    alarmProvider.toggleAlarm(alarm.id);
                  },
                  activeColor: Colors.white,
                  activeTrackColor: primaryColor,
                  inactiveThumbColor: Colors.grey[600],
                  inactiveTrackColor: Colors.grey[800],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
