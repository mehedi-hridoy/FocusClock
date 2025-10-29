import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/color_palette.dart';
import '../../state/settings_provider.dart';
import '../../state/timer_provider.dart';
import '../widgets/custom_color_picker.dart';

/// Fullscreen minimal stopwatch display
class FullscreenStopwatchScreen extends StatefulWidget {
  const FullscreenStopwatchScreen({super.key});

  @override
  State<FullscreenStopwatchScreen> createState() =>
      _FullscreenStopwatchScreenState();
}

class _FullscreenStopwatchScreenState extends State<FullscreenStopwatchScreen>
    with TickerProviderStateMixin {
  bool _showColorPicker = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Pulse animation for running state
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Glow animation for milliseconds
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Set to stopwatch mode
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final timerProvider = Provider.of<TimerProvider>(context, listen: false);
      timerProvider.setMode(TimerMode.stopwatch);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Map<String, String> _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    // Show centiseconds (two digits) for milliseconds
    final centiseconds = twoDigits(
      (duration.inMilliseconds.remainder(1000) ~/ 10),
    );

    return {'minutes': minutes, 'seconds': seconds, 'ms': centiseconds};
  }

  // Helper to build outlined number with FIXED WIDTH and animation
  Widget _buildOutlinedDigit(
    String digit,
    Color color,
    bool isPortrait,
    bool isRunning,
  ) {
    return SizedBox(
      width: isPortrait ? 42.0 : 60.0,
      child: Center(
        child: AnimatedBuilder(
          animation: isRunning
              ? _pulseAnimation
              : const AlwaysStoppedAnimation(1.0),
          builder: (context, child) {
            return Transform.scale(
              scale: isRunning ? _pulseAnimation.value : 1.0,
              child: Text(
                digit,
                style: GoogleFonts.poppins(
                  fontSize: isPortrait ? 70.0 : 100.0,
                  fontWeight: FontWeight.w600,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 3
                    ..color = color.withOpacity(isRunning ? 0.7 : 0.5),
                  height: 1.0,
                  shadows: isRunning
                      ? [Shadow(blurRadius: 20, color: color.withOpacity(0.5))]
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper to build solid digit with FIXED WIDTH and glow animation
  Widget _buildSolidDigit(
    String digit,
    Color color,
    bool isPortrait,
    bool isRunning,
  ) {
    return SizedBox(
      width: isPortrait ? 35.0 : 50.0,
      child: Center(
        child: AnimatedBuilder(
          animation: isRunning
              ? _glowAnimation
              : const AlwaysStoppedAnimation(1.0),
          builder: (context, child) {
            return Text(
              digit,
              style: GoogleFonts.poppins(
                fontSize: isPortrait ? 58.0 : 82.0,
                fontWeight: FontWeight.w600,
                color: color.withOpacity(
                  isRunning ? _glowAnimation.value : 1.0,
                ),
                height: 1.0,
                shadows: isRunning
                    ? [
                        Shadow(blurRadius: 30, color: color.withOpacity(0.8)),
                        Shadow(blurRadius: 15, color: color),
                      ]
                    : [Shadow(blurRadius: 10, color: color.withOpacity(0.3))],
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper to build colon separator
  Widget _buildColon(Color color, bool isPortrait) {
    return SizedBox(
      width: isPortrait ? 18.0 : 28.0, // Fixed width for colon
      child: Center(
        child: Text(
          ':',
          style: GoogleFonts.poppins(
            fontSize: isPortrait ? 70.0 : 100.0,
            fontWeight: FontWeight.w600,
            color: color.withOpacity(0.5),
            height: 1.0,
          ),
        ),
      ),
    );
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

  // Build portrait button (bottom placement)
  Widget _buildPortraitButton(
    TimerProvider timerProvider, {
    required bool isStartPause,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.0),
      duration: const Duration(milliseconds: 150),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTapDown: (_) => setState(() {}),
            onTapUp: (_) => setState(() {}),
            onTap: () => isStartPause
                ? timerProvider.togglePlayPause()
                : timerProvider.reset(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isStartPause
                      ? (timerProvider.isRunning && !timerProvider.isPaused
                            ? [Colors.orange.shade600, Colors.orange.shade700]
                            : [Colors.blue.shade600, Colors.blue.shade700])
                      : [Colors.brown.shade700, Colors.brown.shade800],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color:
                        (isStartPause
                                ? (timerProvider.isRunning &&
                                          !timerProvider.isPaused
                                      ? Colors.orange
                                      : Colors.blue)
                                : Colors.brown)
                            .withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isStartPause
                        ? (timerProvider.isRunning && !timerProvider.isPaused
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded)
                        : Icons.refresh_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isStartPause
                        ? (timerProvider.isRunning && !timerProvider.isPaused
                              ? 'Pause'
                              : timerProvider.elapsed.inSeconds > 0
                              ? 'Resume'
                              : 'Start')
                        : 'Clear',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Build landscape button (side placement - more compact)
  Widget _buildLandscapeButton(
    TimerProvider timerProvider, {
    required bool isStartPause,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.0),
      duration: const Duration(milliseconds: 150),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTapDown: (_) => setState(() {}),
            onTapUp: (_) => setState(() {}),
            onTap: () => isStartPause
                ? timerProvider.togglePlayPause()
                : timerProvider.reset(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isStartPause
                      ? (timerProvider.isRunning && !timerProvider.isPaused
                            ? [Colors.orange.shade600, Colors.orange.shade700]
                            : [Colors.blue.shade600, Colors.blue.shade700])
                      : [Colors.brown.shade700, Colors.brown.shade800],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color:
                        (isStartPause
                                ? (timerProvider.isRunning &&
                                          !timerProvider.isPaused
                                      ? Colors.orange
                                      : Colors.blue)
                                : Colors.brown)
                            .withOpacity(0.4),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isStartPause
                        ? (timerProvider.isRunning && !timerProvider.isPaused
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded)
                        : Icons.refresh_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isStartPause
                        ? (timerProvider.isRunning && !timerProvider.isPaused
                              ? 'Pause'
                              : timerProvider.elapsed.inSeconds > 0
                              ? 'Resume'
                              : 'Start')
                        : 'Clear',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer2<TimerProvider, SettingsProvider>(
        builder: (context, timerProvider, settingsProvider, child) {
          final selectedColor = ColorPalette.getColor(
            settingsProvider.selectedColorIndex,
          );
          final displayColor = Color.lerp(
            selectedColor.withOpacity(0.15),
            selectedColor,
            settingsProvider.brightness,
          )!;

          final timeData = _formatTime(timerProvider.elapsed);
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
            child: Stack(
              children: [
                // Main Stopwatch Display
                Center(
                  child: isPortrait
                      ? // Portrait Layout - Vertical
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Animated circular progress ring
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                // Outer glow ring
                                if (timerProvider.isRunning &&
                                    !timerProvider.isPaused)
                                  AnimatedBuilder(
                                    animation: _glowAnimation,
                                    builder: (context, child) {
                                      return Container(
                                        width: 320,
                                        height: 320,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: displayColor.withOpacity(
                                                0.2 * _glowAnimation.value,
                                              ),
                                              blurRadius: 60,
                                              spreadRadius: 20,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                // Circular progress indicator
                                SizedBox(
                                  width: 280,
                                  height: 280,
                                  child: CircularProgressIndicator(
                                    value:
                                        (timerProvider.elapsed.inSeconds % 60) /
                                        60,
                                    strokeWidth: 2.5,
                                    backgroundColor: displayColor.withOpacity(
                                      0.1,
                                    ),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      displayColor.withOpacity(0.6),
                                    ),
                                  ),
                                ),
                                // Inner content
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Title with fade animation
                                    AnimatedOpacity(
                                      opacity: timerProvider.isRunning
                                          ? 0.4
                                          : 0.6,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child: Text(
                                        'STOPWATCH',
                                        style: GoogleFonts.comfortaa(
                                          fontSize: 14,
                                          color: displayColor,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 4.0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    // Time display
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        _buildOutlinedDigit(
                                          timeData['minutes']![0],
                                          displayColor,
                                          isPortrait,
                                          timerProvider.isRunning &&
                                              !timerProvider.isPaused,
                                        ),
                                        _buildOutlinedDigit(
                                          timeData['minutes']![1],
                                          displayColor,
                                          isPortrait,
                                          timerProvider.isRunning &&
                                              !timerProvider.isPaused,
                                        ),
                                        _buildColon(displayColor, isPortrait),
                                        _buildOutlinedDigit(
                                          timeData['seconds']![0],
                                          displayColor,
                                          isPortrait,
                                          timerProvider.isRunning &&
                                              !timerProvider.isPaused,
                                        ),
                                        _buildOutlinedDigit(
                                          timeData['seconds']![1],
                                          displayColor,
                                          isPortrait,
                                          timerProvider.isRunning &&
                                              !timerProvider.isPaused,
                                        ),
                                        _buildColon(displayColor, isPortrait),
                                        _buildSolidDigit(
                                          timeData['ms']![0],
                                          displayColor,
                                          isPortrait,
                                          timerProvider.isRunning &&
                                              !timerProvider.isPaused,
                                        ),
                                        _buildSolidDigit(
                                          timeData['ms']![1],
                                          displayColor,
                                          isPortrait,
                                          timerProvider.isRunning &&
                                              !timerProvider.isPaused,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                      : // Landscape Layout - Horizontal with buttons on right
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Stopwatch display on left
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                // Outer glow ring (smaller in landscape)
                                if (timerProvider.isRunning &&
                                    !timerProvider.isPaused)
                                  AnimatedBuilder(
                                    animation: _glowAnimation,
                                    builder: (context, child) {
                                      return Container(
                                        width: 280,
                                        height: 280,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: displayColor.withOpacity(
                                                0.2 * _glowAnimation.value,
                                              ),
                                              blurRadius: 40,
                                              spreadRadius: 10,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                // Circular progress indicator (smaller)
                                SizedBox(
                                  width: 260,
                                  height: 260,
                                  child: CircularProgressIndicator(
                                    value:
                                        (timerProvider.elapsed.inSeconds % 60) /
                                        60,
                                    strokeWidth: 2.0,
                                    backgroundColor: displayColor.withOpacity(
                                      0.1,
                                    ),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      displayColor.withOpacity(0.6),
                                    ),
                                  ),
                                ),
                                // Inner content
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Title
                                    AnimatedOpacity(
                                      opacity: timerProvider.isRunning
                                          ? 0.4
                                          : 0.6,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child: Text(
                                        'STOPWATCH',
                                        style: GoogleFonts.comfortaa(
                                          fontSize: 12,
                                          color: displayColor,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 3.0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 25),
                                    // Time display (smaller digits)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        _buildOutlinedDigit(
                                          timeData['minutes']![0],
                                          displayColor,
                                          isPortrait,
                                          timerProvider.isRunning &&
                                              !timerProvider.isPaused,
                                        ),
                                        _buildOutlinedDigit(
                                          timeData['minutes']![1],
                                          displayColor,
                                          isPortrait,
                                          timerProvider.isRunning &&
                                              !timerProvider.isPaused,
                                        ),
                                        _buildColon(displayColor, isPortrait),
                                        _buildOutlinedDigit(
                                          timeData['seconds']![0],
                                          displayColor,
                                          isPortrait,
                                          timerProvider.isRunning &&
                                              !timerProvider.isPaused,
                                        ),
                                        _buildOutlinedDigit(
                                          timeData['seconds']![1],
                                          displayColor,
                                          isPortrait,
                                          timerProvider.isRunning &&
                                              !timerProvider.isPaused,
                                        ),
                                        _buildColon(displayColor, isPortrait),
                                        _buildSolidDigit(
                                          timeData['ms']![0],
                                          displayColor,
                                          isPortrait,
                                          timerProvider.isRunning &&
                                              !timerProvider.isPaused,
                                        ),
                                        _buildSolidDigit(
                                          timeData['ms']![1],
                                          displayColor,
                                          isPortrait,
                                          timerProvider.isRunning &&
                                              !timerProvider.isPaused,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(width: 40),
                            // Buttons on right side in landscape
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Start/Pause Button
                                _buildLandscapeButton(
                                  timerProvider,
                                  isStartPause: true,
                                ),
                                const SizedBox(height: 16),
                                // Clear Button
                                _buildLandscapeButton(
                                  timerProvider,
                                  isStartPause: false,
                                ),
                              ],
                            ),
                          ],
                        ),
                ),

                // Bottom Control Buttons - Only for Portrait
                if (isPortrait)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Start/Pause Button
                        _buildPortraitButton(timerProvider, isStartPause: true),
                        const SizedBox(width: 20),
                        // Clear Button
                        _buildPortraitButton(
                          timerProvider,
                          isStartPause: false,
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
                      child: Center(
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
                              ElevatedButton.icon(
                                onPressed: () async {
                                  _toggleColorPicker();
                                  await showDialog(
                                    context: context,
                                    builder: (context) => CustomColorPicker(
                                      initialColor: settingsProvider
                                          .getActiveColor(),
                                      onColorChanged: (color) {
                                        settingsProvider.setCustomColor(color);
                                      },
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.colorize,
                                  color:
                                      settingsProvider
                                              .getActiveColor()
                                              .computeLuminance() >
                                          0.5
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                label: Text(
                                  'CUSTOM COLOR (RGB)',
                                  style: GoogleFonts.comfortaa(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        settingsProvider
                                                .getActiveColor()
                                                .computeLuminance() >
                                            0.5
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black.withOpacity(
                                    0.3,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: settingsProvider.getActiveColor(),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
