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
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor.withOpacity(0.1),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.alarm_add,
                          size: 80,
                          color: primaryColor.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'No alarms set',
                        style: GoogleFonts.comfortaa(
                          fontSize: 20,
                          color: primaryColor.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap + to add an alarm',
                        style: GoogleFonts.comfortaa(
                          fontSize: 14,
                          color: primaryColor.withOpacity(0.4),
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
          floatingActionButton: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddAlarmScreen()),
              );
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[900],
                border: Border.all(
                  color: primaryColor.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.add,
                color: primaryColor.withOpacity(0.8),
                size: 28,
              ),
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
                // Alarm icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: alarm.isEnabled
                        ? primaryColor.withOpacity(0.15)
                        : Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.alarm,
                    color: alarm.isEnabled
                        ? primaryColor.withOpacity(0.7)
                        : Colors.grey.withOpacity(0.5),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
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
                // Custom toggle switch
                GestureDetector(
                  onTap: () {
                    alarmProvider.toggleAlarm(alarm.id);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: 70,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: alarm.isEnabled ? primaryColor : Colors.grey[800],
                      border: Border.all(
                        color: alarm.isEnabled
                            ? primaryColor
                            : Colors.grey[700]!,
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // ON/OFF text
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: alarm.isEnabled ? 8 : 0,
                              right: alarm.isEnabled ? 0 : 8,
                            ),
                            child: Text(
                              alarm.isEnabled ? 'ON' : 'OFF',
                              style: GoogleFonts.comfortaa(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: alarm.isEnabled
                                    ? Colors.black
                                    : Colors.grey[600],
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        // Animated circle
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          left: alarm.isEnabled ? 36 : 2,
                          top: 2,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
