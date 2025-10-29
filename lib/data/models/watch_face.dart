import 'package:flutter/material.dart';

/// Watch face model
class WatchFace {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color primaryColor;
  final Color? secondaryColor;
  final Widget Function(
    String time,
    String date,
    double brightness,
    bool is24Hour,
  )
  builder;

  const WatchFace({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.primaryColor,
    this.secondaryColor,
    required this.builder,
  });
}
