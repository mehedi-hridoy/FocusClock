import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../state/alarm_provider.dart';
import '../../state/settings_provider.dart';
import '../../core/constants/color_palette.dart';
import '../../data/models/alarm_model.dart';

/// Screen to add or edit an alarm
class AddAlarmScreen extends StatefulWidget {
  final AlarmModel? alarm; // null for new alarm, populated for edit

  const AddAlarmScreen({super.key, this.alarm});

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  late int _selectedHour;
  late int _selectedMinute;
  late bool _isAM;
  late String _label;
  late bool _vibrate;
  late bool _deleteAfterGoesOff;
  late String _ringtone;
  late List<bool> _repeatDays;

  final TextEditingController _labelController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.alarm != null) {
      // Edit mode
      _selectedHour = widget.alarm!.hour;
      _selectedMinute = widget.alarm!.minute;
      _isAM = widget.alarm!.isAM;
      _label = widget.alarm!.label;
      _vibrate = widget.alarm!.vibrate;
      _deleteAfterGoesOff = widget.alarm!.deleteAfterGoesOff;
      _ringtone = widget.alarm!.ringtone;
      _repeatDays = List.from(widget.alarm!.repeatDays);
      _labelController.text = _label;
    } else {
      // New alarm - default to current time + 1 hour
      final now = DateTime.now();
      final futureTime = now.add(const Duration(hours: 1));
      _selectedHour = futureTime.hour > 12
          ? futureTime.hour - 12
          : (futureTime.hour == 0 ? 12 : futureTime.hour);
      _selectedMinute = futureTime.minute;
      _isAM = futureTime.hour < 12;
      _label = '';
      _vibrate = true;
      _deleteAfterGoesOff = false;
      _ringtone = 'Weather alarm';
      _repeatDays = [false, false, false, false, false, false, false];
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  void _saveAlarm() async {
    final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);

    final alarm = AlarmModel(
      id: widget.alarm?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      hour: _selectedHour,
      minute: _selectedMinute,
      isAM: _isAM,
      isEnabled: true,
      label: _label,
      vibrate: _vibrate,
      deleteAfterGoesOff: _deleteAfterGoesOff,
      ringtone: _ringtone,
      repeatDays: _repeatDays,
    );

    if (widget.alarm != null) {
      await alarmProvider.updateAlarm(widget.alarm!.id, alarm);
    } else {
      await alarmProvider.addAlarm(alarm);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _deleteAlarm() async {
    final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
    if (widget.alarm != null) {
      await alarmProvider.deleteAlarm(widget.alarm!.id);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  String _getTimeUntilAlarm() {
    final now = DateTime.now();
    var hour24 = _selectedHour;
    if (!_isAM && _selectedHour != 12) {
      hour24 += 12;
    } else if (_isAM && _selectedHour == 12) {
      hour24 = 0;
    }

    var alarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      hour24,
      _selectedMinute,
    );

    if (alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }

    final difference = alarmTime.difference(now);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    if (hours > 0) {
      return 'Alarm in $hours hours $minutes minutes';
    } else {
      return 'Alarm in $minutes minutes';
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final primaryColor = ColorPalette.getColor(
      settingsProvider.selectedColorIndex,
    );
    final backgroundColor = Colors.black; // Changed to solid black

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.alarm != null ? 'Edit alarm' : 'Add alarm',
          style: GoogleFonts.comfortaa(
            fontSize: 20,
            color: primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: primaryColor),
            onPressed: _saveAlarm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Time until alarm
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                _getTimeUntilAlarm(),
                style: GoogleFonts.comfortaa(
                  fontSize: 14,
                  color: primaryColor.withOpacity(0.6),
                ),
              ),
            ),

            // Time Picker Wheels
            SizedBox(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hour wheel
                  SizedBox(
                    width: 80,
                    child: ListWheelScrollView.useDelegate(
                      controller: FixedExtentScrollController(
                        initialItem: _selectedHour - 1,
                      ),
                      itemExtent: 60,
                      perspective: 0.005,
                      diameterRatio: 1.5,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          _selectedHour = index + 1;
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: 12,
                        builder: (context, index) {
                          final hour = index + 1;
                          final isSelected = hour == _selectedHour;
                          return Center(
                            child: Text(
                              hour.toString().padLeft(2, '0'),
                              style: GoogleFonts.comfortaa(
                                fontSize: isSelected ? 48 : 32,
                                color: isSelected
                                    ? primaryColor
                                    : primaryColor.withOpacity(0.3),
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // AM/PM selector
                  SizedBox(
                    width: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isAM = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _isAM ? primaryColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'AM',
                              style: GoogleFonts.comfortaa(
                                fontSize: 18,
                                color: _isAM
                                    ? Colors.white
                                    : primaryColor.withOpacity(0.4),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isAM = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: !_isAM ? primaryColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'PM',
                              style: GoogleFonts.comfortaa(
                                fontSize: 18,
                                color: !_isAM
                                    ? Colors.white
                                    : primaryColor.withOpacity(0.4),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Minute wheel
                  SizedBox(
                    width: 80,
                    child: ListWheelScrollView.useDelegate(
                      controller: FixedExtentScrollController(
                        initialItem: _selectedMinute,
                      ),
                      itemExtent: 60,
                      perspective: 0.005,
                      diameterRatio: 1.5,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          _selectedMinute = index;
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: 60,
                        builder: (context, index) {
                          final isSelected = index == _selectedMinute;
                          return Center(
                            child: Text(
                              index.toString().padLeft(2, '0'),
                              style: GoogleFonts.comfortaa(
                                fontSize: isSelected ? 48 : 32,
                                color: isSelected
                                    ? primaryColor
                                    : primaryColor.withOpacity(0.3),
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Options
            _buildOptionTile(
              'Ringtone',
              _ringtone,
              primaryColor,
              onTap: () {
                // Show ringtone picker
              },
            ),

            _buildOptionTile(
              'Repeat',
              _getRepeatString(),
              primaryColor,
              onTap: () {
                _showRepeatDialog(primaryColor);
              },
            ),

            _buildSwitchTile(
              'Vibrate when alarm sounds',
              _vibrate,
              primaryColor,
              onChanged: (value) {
                setState(() {
                  _vibrate = value;
                });
              },
            ),

            _buildSwitchTile(
              'Delete after goes off',
              _deleteAfterGoesOff,
              primaryColor,
              onChanged: (value) {
                setState(() {
                  _deleteAfterGoesOff = value;
                });
              },
            ),

            _buildLabelTile(primaryColor),

            // Delete button (only in edit mode)
            if (widget.alarm != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _deleteAlarm,
                  child: Text(
                    'Delete Alarm',
                    style: GoogleFonts.comfortaa(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    String title,
    String value,
    Color primaryColor, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.comfortaa(fontSize: 16, color: primaryColor),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: GoogleFonts.comfortaa(
                    fontSize: 14,
                    color: primaryColor.withOpacity(0.6),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: primaryColor.withOpacity(0.4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    bool value,
    Color primaryColor, {
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.comfortaa(fontSize: 16, color: primaryColor),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: primaryColor,
            activeTrackColor: primaryColor.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelTile(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Label',
            style: GoogleFonts.comfortaa(fontSize: 16, color: primaryColor),
          ),
          SizedBox(
            width: 200,
            child: TextField(
              controller: _labelController,
              textAlign: TextAlign.right,
              style: GoogleFonts.comfortaa(fontSize: 14, color: primaryColor),
              decoration: InputDecoration(
                hintText: 'Enter label',
                hintStyle: GoogleFonts.comfortaa(
                  fontSize: 14,
                  color: primaryColor.withOpacity(0.3),
                ),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                _label = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getRepeatString() {
    if (_repeatDays.every((day) => !day)) {
      return 'Once';
    }
    if (_repeatDays.every((day) => day)) {
      return 'Every day';
    }
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final selectedDays = <String>[];
    for (int i = 0; i < _repeatDays.length; i++) {
      if (_repeatDays[i]) {
        selectedDays.add(days[i]);
      }
    }
    return selectedDays.join(', ');
  }

  void _showRepeatDialog(Color primaryColor) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1a1a1a), // Dark gray background
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: primaryColor, width: 2),
              ),
              title: Text(
                'Repeat',
                style: GoogleFonts.comfortaa(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDayCheckbox('Monday', 0, primaryColor, setDialogState),
                  _buildDayCheckbox('Tuesday', 1, primaryColor, setDialogState),
                  _buildDayCheckbox(
                    'Wednesday',
                    2,
                    primaryColor,
                    setDialogState,
                  ),
                  _buildDayCheckbox(
                    'Thursday',
                    3,
                    primaryColor,
                    setDialogState,
                  ),
                  _buildDayCheckbox('Friday', 4, primaryColor, setDialogState),
                  _buildDayCheckbox(
                    'Saturday',
                    5,
                    primaryColor,
                    setDialogState,
                  ),
                  _buildDayCheckbox('Sunday', 6, primaryColor, setDialogState),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Done',
                    style: GoogleFonts.comfortaa(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDayCheckbox(
    String day,
    int index,
    Color primaryColor,
    StateSetter setDialogState,
  ) {
    return CheckboxListTile(
      title: Text(
        day,
        style: GoogleFonts.comfortaa(color: Colors.white, fontSize: 16),
      ),
      value: _repeatDays[index],
      onChanged: (value) {
        setDialogState(() {
          setState(() {
            _repeatDays[index] = value ?? false;
          });
        });
      },
      activeColor: primaryColor,
      checkColor: Colors.black,
      side: BorderSide(color: Colors.white.withOpacity(0.5), width: 2),
    );
  }
}
