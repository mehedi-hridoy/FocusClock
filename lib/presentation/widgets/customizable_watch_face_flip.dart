import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../../core/constants/color_palette.dart';
import '../../state/settings_provider.dart';
import 'custom_color_picker.dart';

/// Flip Clock Watch Face - Numbers flip like a mechanical clock
class CustomizableWatchFaceFlip extends StatefulWidget {
  final String time;
  final String date;
  final double brightness;

  const CustomizableWatchFaceFlip({
    super.key,
    required this.time,
    required this.date,
    required this.brightness,
  });

  @override
  State<CustomizableWatchFaceFlip> createState() =>
      _CustomizableWatchFaceFlipState();
}

class _CustomizableWatchFaceFlipState extends State<CustomizableWatchFaceFlip>
    with TickerProviderStateMixin {
  bool _showColorPicker = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Store previous time digits for flip animation
  String _prevHour1 = '0';
  String _prevHour2 = '0';
  String _prevMinute1 = '0';
  String _prevMinute2 = '0';
  String _prevSecond1 = '0';
  String _prevSecond2 = '0';

  // Animation controllers for each digit
  late AnimationController _hour1Controller;
  late AnimationController _hour2Controller;
  late AnimationController _minute1Controller;
  late AnimationController _minute2Controller;
  late AnimationController _second1Controller;
  late AnimationController _second2Controller;

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

    // Initialize flip animation controllers
    _hour1Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _hour2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _minute1Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _minute2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _second1Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _second2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hour1Controller.dispose();
    _hour2Controller.dispose();
    _minute1Controller.dispose();
    _minute2Controller.dispose();
    _second1Controller.dispose();
    _second2Controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomizableWatchFaceFlip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.time != widget.time) {
      _checkAndAnimateDigits();
    }
  }

  void _checkAndAnimateDigits() {
    final digits = _parseTimeDigits(widget.time);

    if (digits.length >= 6) {
      if (digits[0] != _prevHour1) {
        _hour1Controller.forward(from: 0);
        _prevHour1 = digits[0];
      }
      if (digits[1] != _prevHour2) {
        _hour2Controller.forward(from: 0);
        _prevHour2 = digits[1];
      }
      if (digits[2] != _prevMinute1) {
        _minute1Controller.forward(from: 0);
        _prevMinute1 = digits[2];
      }
      if (digits[3] != _prevMinute2) {
        _minute2Controller.forward(from: 0);
        _prevMinute2 = digits[3];
      }
      if (digits[4] != _prevSecond1) {
        _second1Controller.forward(from: 0);
        _prevSecond1 = digits[4];
      }
      if (digits[5] != _prevSecond2) {
        _second2Controller.forward(from: 0);
        _prevSecond2 = digits[5];
      }
    }
  }

  List<String> _parseTimeDigits(String time) {
    final cleaned = time.replaceAll(':', '');
    if (cleaned.length >= 6) {
      return [
        cleaned[0],
        cleaned[1],
        cleaned[2],
        cleaned[3],
        cleaned[4],
        cleaned[5],
      ];
    }
    return ['0', '0', '0', '0', '0', '0'];
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

    final digits = _parseTimeDigits(widget.time);
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return GestureDetector(
      onDoubleTap: _toggleColorPicker,
      onVerticalDragEnd: (details) {
        if (_showColorPicker) return;
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! < -500) {
            _cycleColor(true);
          } else if (details.primaryVelocity! > 500) {
            _cycleColor(false);
          }
        }
      },
      onLongPress: () {
        if (!_showColorPicker) {
          Navigator.pop(context);
        }
      },
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            // Main Flip Clock Display
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Date above
                  Text(
                    widget.date,
                    style: GoogleFonts.robotoMono(
                      fontSize: isPortrait ? 12 : 14,
                      color: displayColor.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: isPortrait ? 20 : 30),
                  // Flip digits display - Portrait: Two rows, Landscape: One row
                  isPortrait
                      ? Column(
                          children: [
                            // First row: Hours and Minutes
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FlipDigit(
                                  digit: digits[0],
                                  prevDigit: _prevHour1,
                                  controller: _hour1Controller,
                                  color: displayColor,
                                  isPortrait: true,
                                ),
                                const SizedBox(width: 4),
                                FlipDigit(
                                  digit: digits[1],
                                  prevDigit: _prevHour2,
                                  controller: _hour2Controller,
                                  color: displayColor,
                                  isPortrait: true,
                                ),
                                const SizedBox(width: 12),
                                _buildColonSeparator(displayColor, isPortrait),
                                const SizedBox(width: 12),
                                FlipDigit(
                                  digit: digits[2],
                                  prevDigit: _prevMinute1,
                                  controller: _minute1Controller,
                                  color: displayColor,
                                  isPortrait: true,
                                ),
                                const SizedBox(width: 4),
                                FlipDigit(
                                  digit: digits[3],
                                  prevDigit: _prevMinute2,
                                  controller: _minute2Controller,
                                  color: displayColor,
                                  isPortrait: true,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Second row: Seconds
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Seconds: ',
                                  style: GoogleFonts.robotoMono(
                                    fontSize: 12,
                                    color: displayColor.withOpacity(0.5),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                FlipDigit(
                                  digit: digits[4],
                                  prevDigit: _prevSecond1,
                                  controller: _second1Controller,
                                  color: displayColor,
                                  isPortrait: true,
                                ),
                                const SizedBox(width: 4),
                                FlipDigit(
                                  digit: digits[5],
                                  prevDigit: _prevSecond2,
                                  controller: _second2Controller,
                                  color: displayColor,
                                  isPortrait: true,
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FlipDigit(
                              digit: digits[0],
                              prevDigit: _prevHour1,
                              controller: _hour1Controller,
                              color: displayColor,
                              isPortrait: false,
                            ),
                            const SizedBox(width: 6),
                            FlipDigit(
                              digit: digits[1],
                              prevDigit: _prevHour2,
                              controller: _hour2Controller,
                              color: displayColor,
                              isPortrait: false,
                            ),
                            const SizedBox(width: 16),
                            _buildColonSeparator(displayColor, false),
                            const SizedBox(width: 16),
                            FlipDigit(
                              digit: digits[2],
                              prevDigit: _prevMinute1,
                              controller: _minute1Controller,
                              color: displayColor,
                              isPortrait: false,
                            ),
                            const SizedBox(width: 6),
                            FlipDigit(
                              digit: digits[3],
                              prevDigit: _prevMinute2,
                              controller: _minute2Controller,
                              color: displayColor,
                              isPortrait: false,
                            ),
                            const SizedBox(width: 16),
                            _buildColonSeparator(displayColor, false),
                            const SizedBox(width: 16),
                            FlipDigit(
                              digit: digits[4],
                              prevDigit: _prevSecond1,
                              controller: _second1Controller,
                              color: displayColor,
                              isPortrait: false,
                            ),
                            const SizedBox(width: 6),
                            FlipDigit(
                              digit: digits[5],
                              prevDigit: _prevSecond2,
                              controller: _second2Controller,
                              color: displayColor,
                              isPortrait: false,
                            ),
                          ],
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
                              Text(
                                'Choose Color',
                                style: GoogleFonts.comfortaa(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 32),
                              Expanded(
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 6,
                                        mainAxisSpacing: 16,
                                        crossAxisSpacing: 16,
                                      ),
                                  itemCount: ColorPalette.colors.length,
                                  itemBuilder: (context, index) {
                                    final color = ColorPalette.getColor(index);
                                    final isSelected =
                                        index ==
                                        settingsProvider.selectedColorIndex;

                                    return GestureDetector(
                                      onTap: () {
                                        settingsProvider.setSelectedColorIndex(
                                          index,
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
                                                : Colors.transparent,
                                            width: 3,
                                          ),
                                          boxShadow: isSelected
                                              ? [
                                                  BoxShadow(
                                                    color: color.withOpacity(
                                                      0.5,
                                                    ),
                                                    blurRadius: 16,
                                                    spreadRadius: 2,
                                                  ),
                                                ]
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),
                              TextButton(
                                onPressed: _toggleColorPicker,
                                child: Text(
                                  'CLOSE',
                                  style: GoogleFonts.comfortaa(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
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
                                        color: Colors.white.withOpacity(0.5),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.colorize_rounded,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    'CUSTOM COLOR (RGB)',
                                    style: GoogleFonts.comfortaa(
                                      fontSize: 14,
                                      color: Colors.white,
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

  Widget _buildColonSeparator(Color color, bool isPortrait) {
    final size = isPortrait ? 8.0 : 12.0;
    final spacing = isPortrait ? 12.0 : 20.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(height: spacing),
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ],
    );
  }
}

/// Flip Digit Widget - Animated flip card
class FlipDigit extends StatelessWidget {
  final String digit;
  final String prevDigit;
  final AnimationController controller;
  final Color color;
  final bool isSmall;
  final bool isPortrait;

  const FlipDigit({
    super.key,
    required this.digit,
    required this.prevDigit,
    required this.controller,
    required this.color,
    this.isSmall = false,
    required this.isPortrait,
  });

  @override
  Widget build(BuildContext context) {
    // Portrait mode: smaller size, Landscape: full size
    final width = isSmall ? 50.0 : (isPortrait ? 55.0 : 110.0);
    final height = isSmall ? 70.0 : (isPortrait ? 80.0 : 150.0);
    final fontSize = isSmall ? 50.0 : (isPortrait ? 55.0 : 110.0);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // First half shows old digit flipping down, second half shows new digit
        final isFirstHalf = controller.value < 0.5;
        final displayDigit = isFirstHalf ? prevDigit : digit;

        // Angle for flip: 0 to -π/2 for first half, -π/2 to 0 for second half
        final angle = isFirstHalf
            ? -controller.value * math.pi
            : -(1 - controller.value) * math.pi;

        return SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              // Static bottom half of NEW digit (always visible)
              Positioned(
                bottom: 0,
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    heightFactor: 0.5,
                    child: _buildCard(width, height, fontSize, digit),
                  ),
                ),
              ),
              // Animated top half
              if (controller.value > 0)
                Positioned(
                  top: 0,
                  child: Transform(
                    alignment: Alignment.bottomCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.002)
                      ..rotateX(angle),
                    child: ClipRect(
                      child: Align(
                        alignment: Alignment.topCenter,
                        heightFactor: 0.5,
                        child: _buildCard(
                          width,
                          height,
                          fontSize,
                          displayDigit,
                        ),
                      ),
                    ),
                  ),
                ),
              // Static top half of current digit (when not animating)
              if (controller.value == 0)
                Positioned(
                  top: 0,
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: 0.5,
                      child: _buildCard(width, height, fontSize, digit),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard(double width, double height, double fontSize, String text) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(isSmall ? 8 : 12),
        border: Border.all(
          color: Colors.black.withOpacity(0.5),
          width: isSmall ? 2 : 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: isSmall ? 6 : 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Split line in middle
          Positioned(
            top: height / 2 - 0.5,
            left: 0,
            right: 0,
            child: Container(height: 1, color: Colors.black.withOpacity(0.4)),
          ),
          // Digit
          Center(
            child: Text(
              text,
              style: GoogleFonts.rajdhani(
                fontSize: fontSize,
                color: color,
                fontWeight: FontWeight.w800,
                height: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
