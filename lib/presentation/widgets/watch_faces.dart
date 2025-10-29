import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 1. Neon Cyan Watch Face - Electric mint glow
class NeonCyanWatchFace extends StatelessWidget {
  final String time;
  final String date;
  final double brightness;

  const NeonCyanWatchFace({
    super.key,
    required this.time,
    required this.date,
    this.brightness = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color.lerp(
      const Color(0xFF00FFB0).withOpacity(0.1),
      const Color(0xFF00FFB0),
      brightness,
    )!;

    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              style: GoogleFonts.orbitron(
                fontSize: 120,
                color: color,
                fontWeight: FontWeight.bold,
                letterSpacing: 8.0,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              date,
              style: GoogleFonts.robotoMono(
                fontSize: 22,
                color: color.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 2. LED White Watch Face - Classic LED table clock
class LEDWhiteWatchFace extends StatelessWidget {
  final String time;
  final String date;
  final double brightness;

  const LEDWhiteWatchFace({
    super.key,
    required this.time,
    required this.date,
    this.brightness = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color.lerp(
      Colors.white.withOpacity(0.1),
      Colors.white,
      brightness,
    )!;

    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LED-style segmented display
            Text(
              time,
              style: GoogleFonts.orbitron(
                fontSize: 130,
                color: color,
                fontWeight: FontWeight.w900,
                letterSpacing: 12.0,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              date,
              style: GoogleFonts.robotoMono(
                fontSize: 20,
                color: color.withOpacity(0.8),
                fontWeight: FontWeight.w600,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 3. Red Classic Watch Face - Classic alarm clock red
class RedClassicWatchFace extends StatelessWidget {
  final String time;
  final String date;
  final double brightness;

  const RedClassicWatchFace({
    super.key,
    required this.time,
    required this.date,
    this.brightness = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color.lerp(
      const Color(0xFFFF0000).withOpacity(0.1),
      const Color(0xFFFF0000),
      brightness,
    )!;

    return Container(
      color: const Color(0xFF0A0000), // Very dark red tint
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              style: GoogleFonts.orbitron(
                fontSize: 125,
                color: color,
                fontWeight: FontWeight.w900,
                letterSpacing: 10.0,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              date,
              style: GoogleFonts.robotoMono(
                fontSize: 20,
                color: color.withOpacity(0.75),
                fontWeight: FontWeight.w600,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 4. Gradient Modern Watch Face - Cyan to blue gradient
class GradientModernWatchFace extends StatelessWidget {
  final String time;
  final String date;
  final double brightness;

  const GradientModernWatchFace({
    super.key,
    required this.time,
    required this.date,
    this.brightness = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF001a33).withOpacity(brightness * 0.3),
            const Color(0xFF000d1a).withOpacity(brightness * 0.5),
            Colors.black,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  Color.lerp(
                    const Color(0xFF00BFFF).withOpacity(0.1),
                    const Color(0xFF00BFFF),
                    brightness,
                  )!,
                  Color.lerp(
                    const Color(0xFF1E90FF).withOpacity(0.1),
                    const Color(0xFF1E90FF),
                    brightness,
                  )!,
                  Color.lerp(
                    const Color(0xFF00CED1).withOpacity(0.1),
                    const Color(0xFF00CED1),
                    brightness,
                  )!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                time,
                style: GoogleFonts.orbitron(
                  fontSize: 115,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 6.0,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  Color.lerp(
                    const Color(0xFF00BFFF).withOpacity(0.1),
                    const Color(0xFF00BFFF),
                    brightness * 0.7,
                  )!,
                  Color.lerp(
                    const Color(0xFF00CED1).withOpacity(0.1),
                    const Color(0xFF00CED1),
                    brightness * 0.7,
                  )!,
                ],
              ).createShader(bounds),
              child: Text(
                date,
                style: GoogleFonts.robotoMono(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 5. Segmented Display Watch Face - Classic 7-segment LED style
class SegmentedDisplayWatchFace extends StatelessWidget {
  final String time;
  final String date;
  final double brightness;

  const SegmentedDisplayWatchFace({
    super.key,
    required this.time,
    required this.date,
    this.brightness = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color.lerp(
      const Color(0xFF00FFB0).withOpacity(0.1),
      const Color(0xFF00FFB0),
      brightness,
    )!;

    return Container(
      color: const Color(0xFF0A0A0A),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color.withOpacity(0.3), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Segmented LED-style numbers
              Text(
                time,
                style: GoogleFonts.orbitron(
                  fontSize: 110,
                  color: color,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 16.0,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 16),
              // Date in smaller segmented style
              Text(
                date,
                style: GoogleFonts.robotoMono(
                  fontSize: 18,
                  color: color.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
