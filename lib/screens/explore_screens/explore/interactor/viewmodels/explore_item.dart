import 'package:flutter/material.dart';

class ExploreItem {
  final String title;
  final String? backgroundImage;
  final Widget? icon;
  final Color? backgroundIconColor;
  final bool iconUseCircleBackground;
  final Gradient? gradient;
  final Function onTapEvent;

  const ExploreItem({
    required this.title,
    this.backgroundImage,
    this.icon,
    this.backgroundIconColor,
    this.iconUseCircleBackground = true,
    this.gradient,
    required this.onTapEvent,
  });
}
