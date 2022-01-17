import 'package:flutter/material.dart';
import 'package:seeds/screens/explore_screens/explore/interactor/viewmodels/explore_bloc.dart';

class ExploreItem {
  final String title;
  final String? backgroundImage;
  final Widget? icon;
  final Color? backgroundIconColor;
  final bool iconUseCircleBackground;
  final Gradient? gradient;
  final ExploreEvent onTapEvent;

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
