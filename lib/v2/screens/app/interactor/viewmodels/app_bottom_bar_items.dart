import 'package:flutter/material.dart';

class AppScreensItems {
  final String title;
  final String icon;
  final String iconSelected;
  final int index;
  final Widget screen;

  const AppScreensItems({
    required this.title,
    required this.icon,
    required this.iconSelected,
    required this.index,
    required this.screen,
  });
}
