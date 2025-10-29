import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../state/reminder_provider.dart';
import '../../state/settings_provider.dart';
import '../../data/models/reminder_model.dart';
import 'package:intl/intl.dart';

/// Screen for managing reminders
class RemindMeScreen extends StatefulWidget {
  const RemindMeScreen({super.key});

  @override
  State<RemindMeScreen> createState() => _RemindMeScreenState();
}

class _RemindMeScreenState extends State<RemindMeScreen> {
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReminderProvider>().loadReminders();
    });

    // Update countdown every second
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {}); // Rebuild to update countdown
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _showAddReminderDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddReminderSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reminderProvider = Provider.of<ReminderProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final activeColor = settingsProvider.getActiveColor();

    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: Colors.white,
                    iconSize: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'REMIND ME',
                    style: GoogleFonts.comfortaa(
                      fontSize: 24,
                      color: activeColor,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),
                  if (reminderProvider.reminders.isNotEmpty)
                    IconButton(
                      onPressed: () => _showDeleteAllDialog(context),
                      icon: const Icon(Icons.delete_outline_rounded),
                      color: Colors.white.withOpacity(0.6),
                      iconSize: 24,
                    ),
                ],
              ),
            ),

            // Reminders list
            Expanded(
              child: reminderProvider.isLoading
                  ? Center(child: CircularProgressIndicator(color: activeColor))
                  : reminderProvider.reminders.isEmpty
                  ? _buildEmptyState(activeColor)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: reminderProvider.reminders.length,
                      itemBuilder: (context, index) {
                        final reminder = reminderProvider.reminders[index];
                        return _buildReminderCard(
                          reminder,
                          activeColor,
                          reminderProvider,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add',
        onPressed: _showAddReminderDialog,
        backgroundColor: activeColor,
        icon: Icon(
          Icons.add_rounded,
          color: activeColor.computeLuminance() > 0.5
              ? Colors.black
              : Colors.white,
        ),
        label: Text(
          'NEW REMINDER',
          style: GoogleFonts.comfortaa(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: activeColor.computeLuminance() > 0.5
                ? Colors.black
                : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color activeColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 80,
            color: Colors.white.withOpacity(0.2),
          ),
          const SizedBox(height: 20),
          Text(
            'No Reminders',
            style: GoogleFonts.comfortaa(
              fontSize: 22,
              color: Colors.white.withOpacity(0.4),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to create your first reminder',
            style: GoogleFonts.comfortaa(
              fontSize: 14,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard(
    ReminderModel reminder,
    Color activeColor,
    ReminderProvider provider,
  ) {
    final isPast = reminder.isPast;
    final cardColor = isPast
        ? Colors.white.withOpacity(0.05)
        : Colors.white.withOpacity(0.08);

    return Dismissible(
      key: Key(reminder.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 28),
      ),
      onDismissed: (direction) {
        provider.deleteReminder(reminder.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reminder deleted', style: GoogleFonts.comfortaa()),
            backgroundColor: Colors.black87,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: reminder.isActive && !isPast
                ? activeColor.withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Active toggle
            GestureDetector(
              onTap: () => provider.toggleReminder(reminder.id),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: reminder.isActive && !isPast
                        ? activeColor
                        : Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                  color: reminder.isActive && !isPast
                      ? activeColor
                      : Colors.transparent,
                ),
                child: reminder.isActive && !isPast
                    ? Icon(
                        Icons.check,
                        size: 16,
                        color: activeColor.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 16),

            // Reminder details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.title,
                    style: GoogleFonts.comfortaa(
                      fontSize: 16,
                      color: isPast
                          ? Colors.white.withOpacity(0.4)
                          : Colors.white,
                      fontWeight: FontWeight.w600,
                      decoration: isPast ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (reminder.description != null &&
                      reminder.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      reminder.description!,
                      style: GoogleFonts.comfortaa(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: isPast
                            ? Colors.red.withOpacity(0.6)
                            : activeColor.withOpacity(0.8),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        reminder.getFormattedDateTime(),
                        style: GoogleFonts.comfortaa(
                          fontSize: 12,
                          color: isPast
                              ? Colors.red.withOpacity(0.6)
                              : activeColor.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  // Show countdown if not past
                  if (!isPast && reminder.isActive) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: activeColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: activeColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 12,
                            color: activeColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            reminder.getTimeRemainingString(),
                            style: GoogleFonts.rajdhani(
                              fontSize: 13,
                              color: activeColor,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Edit button
            IconButton(
              onPressed: () => _showEditReminderDialog(reminder),
              icon: const Icon(Icons.edit_outlined),
              color: Colors.white.withOpacity(0.4),
              iconSize: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showEditReminderDialog(ReminderModel reminder) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddReminderSheet(reminder: reminder),
    );
  }

  void _showDeleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a1a),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete All Reminders?',
          style: GoogleFonts.comfortaa(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'This will permanently delete all your reminders.',
          style: GoogleFonts.comfortaa(color: Colors.white.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: GoogleFonts.comfortaa(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<ReminderProvider>().clearAllReminders();
              Navigator.pop(context);
            },
            child: Text(
              'DELETE',
              style: GoogleFonts.comfortaa(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet for adding/editing reminders
class AddReminderSheet extends StatefulWidget {
  final ReminderModel? reminder;

  const AddReminderSheet({super.key, this.reminder});

  @override
  State<AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends State<AddReminderSheet> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.reminder?.title);
    _descriptionController = TextEditingController(
      text: widget.reminder?.description,
    );
    _selectedDate = widget.reminder?.dateTime ?? DateTime.now();
    _selectedTime = TimeOfDay.fromDateTime(
      widget.reminder?.dateTime ?? DateTime.now(),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: context.read<SettingsProvider>().getActiveColor(),
              surface: const Color(0xFF1a1a1a),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: context.read<SettingsProvider>().getActiveColor(),
              surface: const Color(0xFF1a1a1a),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveReminder() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a title', style: GoogleFonts.comfortaa()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    if (widget.reminder != null) {
      // Update existing reminder
      context.read<ReminderProvider>().updateReminder(
        widget.reminder!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          dateTime: dateTime,
        ),
      );
    } else {
      // Add new reminder
      context.read<ReminderProvider>().addReminder(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        dateTime: dateTime,
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final activeColor = settingsProvider.getActiveColor();
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      decoration: const BoxDecoration(
        color: Color(0xFF1a1a1a),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text(
                  widget.reminder != null ? 'Edit Reminder' : 'New Reminder',
                  style: GoogleFonts.comfortaa(
                    fontSize: 22,
                    color: activeColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  color: Colors.white.withOpacity(0.6),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Title field
            TextField(
              controller: _titleController,
              style: GoogleFonts.comfortaa(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: GoogleFonts.comfortaa(
                  color: Colors.white.withOpacity(0.6),
                ),
                hintText: 'Enter reminder title',
                hintStyle: GoogleFonts.comfortaa(
                  color: Colors.white.withOpacity(0.3),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: activeColor, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Description field
            TextField(
              controller: _descriptionController,
              style: GoogleFonts.comfortaa(color: Colors.white, fontSize: 14),
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description (Optional)',
                labelStyle: GoogleFonts.comfortaa(
                  color: Colors.white.withOpacity(0.6),
                ),
                hintText: 'Add details...',
                hintStyle: GoogleFonts.comfortaa(
                  color: Colors.white.withOpacity(0.3),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: activeColor, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Date picker
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: activeColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: activeColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date',
                            style: GoogleFonts.comfortaa(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('EEEE, MMM d, y').format(_selectedDate),
                            style: GoogleFonts.comfortaa(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white.withOpacity(0.4),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Time picker
            GestureDetector(
              onTap: _selectTime,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: activeColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: activeColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time',
                            style: GoogleFonts.comfortaa(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedTime.format(context),
                            style: GoogleFonts.comfortaa(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white.withOpacity(0.4),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveReminder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: activeColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8,
                ),
                child: Text(
                  widget.reminder != null
                      ? 'UPDATE REMINDER'
                      : 'CREATE REMINDER',
                  style: GoogleFonts.comfortaa(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: activeColor.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
