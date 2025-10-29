import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Utility functions for screen responsiveness
class ScreenUtils {
  // Private constructor to prevent instantiation
  ScreenUtils._();

  /// Initialize ScreenUtil with design size
  /// Should be called in main.dart
  static void init(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(960, 540), // Landscape design size
      minTextAdapt: true,
    );
  }

  /// Get screen width
  static double get screenWidth => ScreenUtil().screenWidth;

  /// Get screen height
  static double get screenHeight => ScreenUtil().screenHeight;

  /// Get responsive width
  static double width(double width) => width.w;

  /// Get responsive height
  static double height(double height) => height.h;

  /// Get responsive font size
  static double fontSize(double size) => size.sp;

  /// Get responsive radius
  static double radius(double radius) => radius.r;

  /// Get horizontal spacing
  static Widget horizontalSpace(double width) => SizedBox(width: width.w);

  /// Get vertical spacing
  static Widget verticalSpace(double height) => SizedBox(height: height.h);

  /// Get responsive padding
  static EdgeInsets padding({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return EdgeInsets.only(
      left: (left ?? horizontal ?? all ?? 0).w,
      top: (top ?? vertical ?? all ?? 0).h,
      right: (right ?? horizontal ?? all ?? 0).w,
      bottom: (bottom ?? vertical ?? all ?? 0).h,
    );
  }

  /// Check if device is landscape
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Check if device is portrait
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Get device pixel ratio
  static double getPixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  /// Get status bar height
  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  /// Get bottom padding (for safe area)
  static double getBottomPadding(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }
}
