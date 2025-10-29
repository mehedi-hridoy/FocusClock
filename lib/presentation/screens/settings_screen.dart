import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../state/settings_provider.dart';
import '../../state/clock_provider.dart';

/// Settings screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Settings', style: AppTextStyles.title(fontSize: 20)),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: Consumer<SettingsProvider>(
          builder: (context, settingsProvider, child) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Time Format Section
                _buildSectionTitle('TIME FORMAT'),
                const SizedBox(height: 12),
                _buildTimeFormatCard(context, settingsProvider),
                const SizedBox(height: 24),

                // Brightness Section
                _buildSectionTitle('BRIGHTNESS'),
                const SizedBox(height: 12),
                _buildBrightnessCard(context, settingsProvider),
                const SizedBox(height: 24),

                // Timezone Section
                _buildSectionTitle('TIMEZONE'),
                const SizedBox(height: 12),
                _buildTimezoneCard(context),
                const SizedBox(height: 24),

                // About Section
                _buildSectionTitle('ABOUT'),
                const SizedBox(height: 12),
                _buildAboutCard(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: AppTextStyles.label(
          fontSize: 12,
          color: AppColors.secondaryText,
        ),
      ),
    );
  }

  Widget _buildTimeFormatCard(
    BuildContext context,
    SettingsProvider settingsProvider,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.buttonBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryNeon.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.access_time, color: AppColors.primaryNeon),
            title: Text(
              'Time Format',
              style: AppTextStyles.buttonText(
                fontSize: 16,
                color: AppColors.secondaryText,
              ),
            ),
            subtitle: Text(
              'Choose between 12-hour or 24-hour format',
              style: AppTextStyles.label(
                fontSize: 12,
                color: AppColors.secondaryText.withOpacity(0.7),
              ),
            ),
          ),
          const Divider(
            color: AppColors.secondaryText,
            height: 1,
            thickness: 0.5,
            indent: 16,
            endIndent: 16,
          ),
          Row(
            children: [
              Expanded(
                child: _buildTimeFormatOption(
                  context,
                  settingsProvider,
                  '12H',
                  false,
                  Icons.schedule,
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: AppColors.secondaryText.withOpacity(0.3),
              ),
              Expanded(
                child: _buildTimeFormatOption(
                  context,
                  settingsProvider,
                  '24H',
                  true,
                  Icons.timelapse,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFormatOption(
    BuildContext context,
    SettingsProvider settingsProvider,
    String label,
    bool is24Hour,
    IconData icon,
  ) {
    final isSelected = settingsProvider.is24HourFormat == is24Hour;

    return InkWell(
      onTap: () => settingsProvider.set24HourFormat(is24Hour),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryNeon.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primaryNeon
                  : AppColors.secondaryText,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.buttonText(
                fontSize: 16,
                color: isSelected
                    ? AppColors.primaryNeon
                    : AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrightnessCard(
    BuildContext context,
    SettingsProvider settingsProvider,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.buttonBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryNeon.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.brightness_6, color: AppColors.primaryNeon),
              const SizedBox(width: 12),
              Text(
                'Screen Brightness',
                style: AppTextStyles.buttonText(
                  fontSize: 16,
                  color: AppColors.secondaryText,
                ),
              ),
              const Spacer(),
              Text(
                '${settingsProvider.getBrightnessPercentage()}%',
                style: AppTextStyles.buttonText(
                  fontSize: 16,
                  color: AppColors.primaryNeon,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.brightness_low,
                color: AppColors.secondaryText.withOpacity(0.5),
                size: 20,
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: AppColors.primaryNeon,
                    inactiveTrackColor: AppColors.secondaryText.withOpacity(
                      0.3,
                    ),
                    thumbColor: AppColors.primaryNeon,
                    overlayColor: AppColors.primaryNeon.withOpacity(0.2),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 10,
                    ),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: settingsProvider.brightness,
                    min: 0.1,
                    max: 1.0,
                    onChanged: (value) {
                      settingsProvider.setBrightness(value);
                    },
                  ),
                ),
              ),
              Icon(
                Icons.brightness_high,
                color: AppColors.primaryNeon,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimezoneCard(BuildContext context) {
    return Consumer<ClockProvider>(
      builder: (context, clockProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.buttonBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primaryNeon.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: ListTile(
            leading: Icon(Icons.public, color: AppColors.primaryNeon),
            title: Text(
              'Timezone',
              style: AppTextStyles.buttonText(
                fontSize: 16,
                color: AppColors.secondaryText,
              ),
            ),
            subtitle: Text(
              clockProvider.getTimezoneDisplayName(),
              style: AppTextStyles.label(
                fontSize: 12,
                color: AppColors.primaryNeon.withOpacity(0.8),
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: AppColors.secondaryText,
              size: 16,
            ),
            onTap: () => _showTimezoneDialog(context, clockProvider),
          ),
        );
      },
    );
  }

  Widget _buildAboutCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.buttonBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryNeon.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.info_outline, color: AppColors.primaryNeon),
            title: Text(
              'Focus Clock',
              style: AppTextStyles.buttonText(
                fontSize: 16,
                color: AppColors.secondaryText,
              ),
            ),
            subtitle: Text(
              'Version 1.0.0',
              style: AppTextStyles.label(
                fontSize: 12,
                color: AppColors.secondaryText.withOpacity(0.7),
              ),
            ),
          ),
          const Divider(
            color: AppColors.secondaryText,
            height: 1,
            thickness: 0.5,
            indent: 16,
            endIndent: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'A minimal, professional-grade LED table clock replacement app with multiple watch faces, auto timezone detection, and customizable settings.',
              style: AppTextStyles.label(
                fontSize: 12,
                color: AppColors.secondaryText.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _showTimezoneDialog(BuildContext context, ClockProvider clockProvider) {
    final timezones = clockProvider.getAvailableTimezones();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.buttonBackground,
        title: Text(
          'Select Timezone',
          style: TextStyle(color: AppColors.primaryNeon),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: timezones.map((tz) {
            return ListTile(
              title: Text(
                tz['label']!,
                style: TextStyle(color: AppColors.secondaryText),
              ),
              subtitle: Text(
                tz['offset']!,
                style: TextStyle(
                  color: AppColors.secondaryText.withOpacity(0.7),
                ),
              ),
              leading: Icon(Icons.schedule, color: AppColors.primaryNeon),
              onTap: () {
                clockProvider.setTimezone(tz['value']!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.secondaryText),
            ),
          ),
        ],
      ),
    );
  }
}
