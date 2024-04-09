import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';

enum SnackType { info, success, failure }

class Snack extends SnackBar {
  final String title;
  final ScaffoldMessengerState scaffoldMessengerState;

  factory Snack(String title, ScaffoldMessengerState scaffoldMessengerState, SnackType type) {
    late Color color;
    Duration duration = const Duration(seconds: 4);
    switch (type) {
      case SnackType.success:
        color = AppColors.canopy;
        break;
      case SnackType.failure:
        color = AppColors.red;
        duration = const Duration(seconds: 6);
        break;
      default:
        color = AppColors.grey;
    }
    return Snack._(title, scaffoldMessengerState, color: color, duration: duration);
  }

  Snack._(this.title, this.scaffoldMessengerState, {Key? key, required Color color, required Duration duration})
      : super(
          key: key,
          backgroundColor: color,
          duration: duration,
          content: Row(
            children: [
              Expanded(child: Text(title, textAlign: TextAlign.center)),
              InkWell(
                onTap: () => scaffoldMessengerState.hideCurrentSnackBar(),
                child: const Icon(Icons.close),
              ),
            ],
          ),
        );

  void show() => scaffoldMessengerState.showSnackBar(this);
}
