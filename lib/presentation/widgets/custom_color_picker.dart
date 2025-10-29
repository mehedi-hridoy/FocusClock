import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../state/settings_provider.dart';

/// Custom color picker widget with color wheel
class CustomColorPicker extends StatefulWidget {
  final Color initialColor;
  final Function(Color) onColorChanged;

  const CustomColorPicker({
    super.key,
    required this.initialColor,
    required this.onColorChanged,
  });

  @override
  State<CustomColorPicker> createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;
  }

  void _updateColor(Color color) {
    setState(() {
      _currentColor = color;
    });
    // Don't call onColorChanged here - only call it when Apply is pressed
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.85, // Prevent overflow
        maxWidth: isPortrait ? double.infinity : 600,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1a1a1a),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _currentColor, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'CUSTOM COLOR',
                style: GoogleFonts.comfortaa(
                  fontSize: 20,
                  color: _currentColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              // Color Wheel
              ColorPicker(
                pickerColor: _currentColor,
                onColorChanged: _updateColor,
                pickerAreaHeightPercent: 0.8,
                displayThumbColor: true,
                paletteType: PaletteType.hueWheel,
                labelTypes: const [],
                enableAlpha: false,
                hexInputBar: false,
                portraitOnly: true,
                colorPickerWidth: isPortrait ? 280 : 240,
                pickerAreaBorderRadius: BorderRadius.circular(20),
              ),
              const SizedBox(height: 20),

              // Color preview with hex
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _currentColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _currentColor.withOpacity(0.5),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '#${_currentColor.value.toRadixString(16).substring(2).toUpperCase()}',
                    style: GoogleFonts.comfortaa(
                      fontSize: 18,
                      color: _currentColor.computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.3),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        'CANCEL',
                        style: GoogleFonts.comfortaa(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        // Save the custom color
                        final settingsProvider = Provider.of<SettingsProvider>(
                          context,
                          listen: false,
                        );
                        await settingsProvider.setCustomColor(_currentColor);
                        // Call the callback to notify parent
                        widget.onColorChanged(_currentColor);
                        if (context.mounted) {
                          Navigator.of(context).pop(true);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                      ),
                      child: Text(
                        'APPLY',
                        style: GoogleFonts.comfortaa(
                          fontSize: 14,
                          color: _currentColor.computeLuminance() > 0.5
                              ? Colors.black
                              : Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
