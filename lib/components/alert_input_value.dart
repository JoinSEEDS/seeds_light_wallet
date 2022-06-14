import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';

class AlertInputValue extends StatelessWidget {
  final String text;
  final bool isVisible;

  const AlertInputValue(this.text, {super.key, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const SizedBox(height: 25),
        if (isVisible)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(color: AppColors.darkGreen2, borderRadius: BorderRadius.circular(6)),
                child: Text(text, style: Theme.of(context).textTheme.subtitle2),
              ),
            ],
          ),
      ],
    );
  }
}
