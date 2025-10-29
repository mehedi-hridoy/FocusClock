import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// Reusable neon-style button
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final bool isOutlined;
  final bool isDisabled;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.color,
    this.textColor,
    this.width,
    this.height,
    this.isOutlined = true,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = isDisabled
        ? AppColors.buttonDisabled
        : (color ?? AppColors.primaryNeon);
    final labelColor = isDisabled
        ? AppColors.secondaryText
        : (textColor ?? buttonColor);

    return SizedBox(
      width: width,
      height: height ?? 50,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined
              ? AppColors.buttonBackground
              : buttonColor,
          foregroundColor: labelColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isOutlined ? buttonColor : Colors.transparent,
              width: isOutlined ? 2 : 0,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: labelColor, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: AppTextStyles.buttonText(fontSize: 14, color: labelColor),
            ),
          ],
        ),
      ),
    );
  }
}

/// Icon-only button variant
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;
  final String? tooltip;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size = 24,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      color: color ?? AppColors.primaryNeon,
      iconSize: size,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.buttonBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color ?? AppColors.primaryNeon, width: 2),
        ),
        padding: const EdgeInsets.all(12),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}
