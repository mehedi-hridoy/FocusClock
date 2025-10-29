import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/color_palette.dart';
import '../../state/settings_provider.dart';
import '../../state/clock_provider.dart';
import '../../core/utils/time_utils.dart';
import 'custom_color_picker.dart';

/// Segmented LED Display Watch Face - 7-segment style with tiny date
class CustomizableWatchFaceSegment extends StatefulWidget {
  final String time;
  final String date;
  final double brightness;

  const CustomizableWatchFaceSegment({
    super.key,
    required this.time,
    required this.date,
    required this.brightness,
  });

  @override
  State<CustomizableWatchFaceSegment> createState() =>
      _CustomizableWatchFaceSegmentState();
}

class _CustomizableWatchFaceSegmentState
    extends State<CustomizableWatchFaceSegment>
    with SingleTickerProviderStateMixin {
  bool _showColorPicker = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleColorPicker() {
    setState(() {
      _showColorPicker = !_showColorPicker;
      if (_showColorPicker) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _cycleColor(bool forward) {
    final settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );
    final currentIndex = settingsProvider.selectedColorIndex;
    final totalColors = ColorPalette.colors.length;

    int newIndex;
    if (forward) {
      newIndex = (currentIndex + 1) % totalColors;
    } else {
      newIndex = (currentIndex - 1 + totalColors) % totalColors;
    }

    settingsProvider.setSelectedColorIndex(newIndex);
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final selectedColor = settingsProvider.getActiveColor();
    final displayColor = Color.lerp(
      selectedColor.withOpacity(0.15),
      selectedColor,
      widget.brightness,
    )!;

    // Get screen orientation and size
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Split time into parts: HH:MM and SS
    final timeParts = widget.time.split(':');
    final hourMinute = timeParts.length >= 2
        ? '${timeParts[0]}:${timeParts[1]}'
        : widget.time;
    final seconds = timeParts.length >= 3 ? timeParts[2] : '';

    // Calculate responsive font size to prevent overflow and shaking
    double calculateMainFontSize() {
      if (isPortrait) {
        // Portrait mode - HH:MM on first line
        final availableWidth = screenWidth - 60;
        final hasAmPm = !settingsProvider.is24HourFormat;
        final widthMultiplier = hasAmPm ? 3.0 : 2.5;
        final calculatedSize = availableWidth / widthMultiplier;
        return calculatedSize.clamp(60.0, 140.0);
      } else {
        // Landscape mode - HH:MM:SS on one line, SS is smaller
        final availableHeight = screenHeight - 100;
        final calculatedSize = availableHeight * 0.65;
        return calculatedSize.clamp(80.0, 140.0);
      }
    }

    final mainFontSize = calculateMainFontSize();
    final secondsFontSize = isPortrait
        ? mainFontSize * 0.5
        : mainFontSize * 0.7; // Smaller seconds
    final amPmFontSize = mainFontSize * 0.18;

    return GestureDetector(
      onDoubleTap: _toggleColorPicker,
      onVerticalDragEnd: (details) {
        if (_showColorPicker) return; // Don't cycle when picker is open

        // Swipe up = next color, swipe down = previous color
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! < -500) {
            // Swiped up (fast enough)
            _cycleColor(true);
          } else if (details.primaryVelocity! > 500) {
            // Swiped down (fast enough)
            _cycleColor(false);
          }
        }
      },
      onLongPress: () {
        // Long press to exit if not showing color picker
        if (!_showColorPicker) {
          Navigator.pop(context);
        }
      },
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            // Main Clock Display - 7-Segment LED Style
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: isPortrait
                      ? // Portrait: Two lines (HH:MM on top, SS below)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // First line: HH:MM with AM/PM
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  hourMinute,
                                  style: GoogleFonts.orbitron(
                                    fontSize: mainFontSize,
                                    color: displayColor,
                                    fontWeight: FontWeight.w200,
                                    letterSpacing: -5.0,
                                    height: 0.85,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                                if (!settingsProvider.is24HourFormat)
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: mainFontSize * 0.1,
                                      bottom: mainFontSize * 0.25,
                                    ),
                                    child: Text(
                                      TimeUtils.getAmPm(
                                        Provider.of<ClockProvider>(
                                          context,
                                        ).clockModel.currentTime,
                                      ),
                                      style: GoogleFonts.orbitron(
                                        fontSize: amPmFontSize,
                                        color: displayColor.withOpacity(0.7),
                                        fontWeight: FontWeight.w400,
                                        height: 1.0,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            // Second line: SS (seconds)
                            if (seconds.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(
                                  top: mainFontSize * 0.1,
                                ),
                                child: Text(
                                  seconds,
                                  style: GoogleFonts.orbitron(
                                    fontSize: secondsFontSize,
                                    color: displayColor.withOpacity(0.8),
                                    fontWeight: FontWeight.w200,
                                    letterSpacing: -3.0,
                                    height: 0.85,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        )
                      : // Landscape: One line (HH:MM:SS with smaller seconds)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // HH:MM part
                            Text(
                              hourMinute,
                              style: GoogleFonts.orbitron(
                                fontSize: mainFontSize,
                                color: displayColor,
                                fontWeight: FontWeight.w200,
                                letterSpacing: -5.0,
                                height: 0.85,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                            // :SS part (smaller)
                            if (seconds.isNotEmpty)
                              Text(
                                ':$seconds',
                                style: GoogleFonts.orbitron(
                                  fontSize: secondsFontSize,
                                  color: displayColor.withOpacity(0.9),
                                  fontWeight: FontWeight.w200,
                                  letterSpacing: -3.0,
                                  height: 0.85,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                            // AM/PM
                            if (!settingsProvider.is24HourFormat)
                              Padding(
                                padding: EdgeInsets.only(
                                  left: mainFontSize * 0.1,
                                  bottom: mainFontSize * 0.2,
                                ),
                                child: Text(
                                  TimeUtils.getAmPm(
                                    Provider.of<ClockProvider>(
                                      context,
                                    ).clockModel.currentTime,
                                  ),
                                  style: GoogleFonts.orbitron(
                                    fontSize: amPmFontSize,
                                    color: displayColor.withOpacity(0.7),
                                    fontWeight: FontWeight.w400,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                          ],
                        ),
                ),
              ),
            ),

            // Color Picker Overlay
            if (_showColorPicker)
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  color: Colors.black.withOpacity(0.85),
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          constraints: const BoxConstraints(
                            maxWidth: 700,
                            maxHeight: 500,
                          ),
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Title
                              Text(
                                'Choose Color',
                                style: GoogleFonts.orbitron(
                                  fontSize: 28,
                                  color: displayColor,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.0,
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Color Grid
                              Flexible(
                                child: SingleChildScrollView(
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 6,
                                          crossAxisSpacing: 16,
                                          mainAxisSpacing: 16,
                                          childAspectRatio: 1,
                                        ),
                                    itemCount: ColorPalette.colors.length,
                                    itemBuilder: (context, index) {
                                      final color = ColorPalette.colors[index];
                                      final isSelected =
                                          index ==
                                          settingsProvider.selectedColorIndex;

                                      return GestureDetector(
                                        onTap: () {
                                          settingsProvider
                                              .setSelectedColorIndex(index);
                                          Future.delayed(
                                            const Duration(milliseconds: 200),
                                            () {
                                              _toggleColorPicker();
                                            },
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: color,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.white.withOpacity(
                                                      0.2,
                                                    ),
                                              width: isSelected ? 3 : 1,
                                            ),
                                            boxShadow: isSelected
                                                ? [
                                                    BoxShadow(
                                                      color: color.withOpacity(
                                                        0.5,
                                                      ),
                                                      blurRadius: 12,
                                                      spreadRadius: 2,
                                                    ),
                                                  ]
                                                : null,
                                          ),
                                          child: isSelected
                                              ? const Icon(
                                                  Icons.check,
                                                  color: Colors.black,
                                                  size: 32,
                                                )
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Custom Color Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    await showDialog<bool>(
                                      context: context,
                                      builder: (context) => Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: CustomColorPicker(
                                          initialColor: settingsProvider
                                              .getActiveColor(),
                                          onColorChanged: (color) {
                                            settingsProvider.setCustomColor(
                                              color,
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                    if (context.mounted) {
                                      _toggleColorPicker();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black.withOpacity(
                                      0.3,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: displayColor.withOpacity(0.5),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.colorize_rounded,
                                    color: displayColor,
                                  ),
                                  label: Text(
                                    'CUSTOM COLOR (RGB)',
                                    style: GoogleFonts.comfortaa(
                                      fontSize: 14,
                                      color: displayColor,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Close button
                      Positioned(
                        top: 40,
                        right: 40,
                        child: IconButton(
                          onPressed: _toggleColorPicker,
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.5),
                            padding: const EdgeInsets.all(12),
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
    );
  }
}
