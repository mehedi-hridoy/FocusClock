import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/color_palette.dart';
import '../../state/settings_provider.dart';
import '../../state/clock_provider.dart';
import '../../core/utils/time_utils.dart';
import 'custom_color_picker.dart';

/// Large Customizable Watch Face - No date, bigger font, cute style
class CustomizableWatchFaceLarge extends StatefulWidget {
  final String time;
  final String date;
  final double brightness;

  const CustomizableWatchFaceLarge({
    super.key,
    required this.time,
    required this.date,
    required this.brightness,
  });

  @override
  State<CustomizableWatchFaceLarge> createState() =>
      _CustomizableWatchFaceLargeState();
}

class _CustomizableWatchFaceLargeState extends State<CustomizableWatchFaceLarge>
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

  // Helper to build clock digit with FIXED WIDTH
  Widget _buildClockDigit(String digit, Color color, bool isPortrait) {
    return SizedBox(
      width: isPortrait ? 50.0 : 100.0, // Fixed width for each digit
      child: Center(
        child: Text(
          digit,
          style: GoogleFonts.comfortaa(
            fontSize: isPortrait ? 90.0 : 180.0,
            color: color,
            fontWeight: FontWeight.w700,
            height: 1.0,
          ),
        ),
      ),
    );
  }

  // Helper to build colon separator
  Widget _buildClockColon(Color color, bool isPortrait) {
    return SizedBox(
      width: isPortrait ? 25.0 : 50.0, // Fixed width for colon
      child: Center(
        child: Text(
          ':',
          style: GoogleFonts.comfortaa(
            fontSize: isPortrait ? 90.0 : 180.0,
            color: color,
            fontWeight: FontWeight.w700,
            height: 1.0,
          ),
        ),
      ),
    );
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

    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

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
            // Main Clock Display - Large, No Date, Fixed-Width Digits
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  // Build each character (digit or colon) with fixed width
                  for (var char in widget.time.split(''))
                    if (char == ':')
                      _buildClockColon(displayColor, isPortrait)
                    else
                      _buildClockDigit(char, displayColor, isPortrait),
                  // AM/PM indicator (tiny)
                  if (!settingsProvider.is24HourFormat)
                    Padding(
                      padding: EdgeInsets.only(
                        left: isPortrait ? 10 : 20,
                        bottom: isPortrait ? 30 : 70,
                      ),
                      child: Text(
                        TimeUtils.getAmPm(
                          Provider.of<ClockProvider>(
                            context,
                          ).clockModel.currentTime,
                        ),
                        style: GoogleFonts.comfortaa(
                          fontSize: isPortrait ? 18 : 32,
                          color: displayColor.withOpacity(0.7),
                          fontWeight: FontWeight.w700,
                          height: 1.0,
                        ),
                      ),
                    ),
                ],
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
                                style: GoogleFonts.comfortaa(
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
                                    // Close the color picker overlay after custom color dialog
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

                      // Close button at top right
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
