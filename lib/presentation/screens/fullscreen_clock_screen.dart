import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/time_utils.dart';
import '../../state/clock_provider.dart';
import '../../state/settings_provider.dart';
import '../widgets/customizable_watch_face.dart';
import '../widgets/customizable_watch_face_large.dart';
import '../widgets/customizable_watch_face_segment.dart';
import '../widgets/customizable_watch_face_rounded.dart';
import '../widgets/customizable_watch_face_flip.dart';

/// Fullscreen clock screen - immersive clock display
class FullscreenClockScreen extends StatefulWidget {
  const FullscreenClockScreen({super.key});

  @override
  State<FullscreenClockScreen> createState() => _FullscreenClockScreenState();
}

class _FullscreenClockScreenState extends State<FullscreenClockScreen> {
  final PageController _pageController = PageController();
  final List<String> _watchFaceIds = [
    'standard',
    'large',
    'segment',
    'rounded',
    'flip',
  ];

  @override
  void initState() {
    super.initState();
    // Hide system UI for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Set initial page based on saved watch face
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settingsProvider = Provider.of<SettingsProvider>(
        context,
        listen: false,
      );
      final initialIndex = _watchFaceIds.indexOf(
        settingsProvider.selectedWatchFace,
      );
      if (initialIndex != -1 && initialIndex != 0) {
        _pageController.jumpToPage(initialIndex);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _onPageChanged(int index) {
    final settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );
    settingsProvider.setSelectedWatchFace(_watchFaceIds[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer2<ClockProvider, SettingsProvider>(
        builder: (context, clockProvider, settingsProvider, child) {
          // Format time based on 12H/24H setting
          final time = settingsProvider.is24HourFormat
              ? clockProvider.currentTimeString
              : TimeUtils.formatTime12Hour(
                  clockProvider.clockModel.currentTime,
                ).split(' ').first; // Get time without AM/PM for now

          final date = clockProvider.currentDateString;
          final brightness = settingsProvider.brightness;

          return PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              // Watch Face 1: Standard with date
              CustomizableWatchFace(
                time: time,
                date: date,
                brightness: brightness,
              ),
              // Watch Face 2: Large without date
              CustomizableWatchFaceLarge(
                time: time,
                date: date,
                brightness: brightness,
              ),
              // Watch Face 3: 7-Segment LED with tiny date
              CustomizableWatchFaceSegment(
                time: time,
                date: date,
                brightness: brightness,
              ),
              // Watch Face 4: Extra large rounded without seconds
              CustomizableWatchFaceRounded(
                time: time,
                date: date,
                brightness: brightness,
              ),
              // Watch Face 5: Flip clock with animations
              CustomizableWatchFaceFlip(
                time: time,
                date: date,
                brightness: brightness,
              ),
            ],
          );
        },
      ),
    );
  }
}
