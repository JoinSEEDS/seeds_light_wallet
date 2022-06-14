import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class CircularProgressItem extends StatelessWidget {
  final Widget icon;
  final int totalStep;
  final int currentStep;
  final double circleRadius;
  final String title;
  final TextStyle titleStyle;
  final String rate;
  final TextStyle rateStyle;
  final VoidCallback? onPressed;

  const CircularProgressItem({
    super.key,
    required this.icon,
    required this.totalStep,
    required this.currentStep,
    required this.circleRadius,
    required this.title,
    required this.titleStyle,
    required this.rate,
    required this.rateStyle,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: onPressed,
          child: CircularStepProgressIndicator(
            totalSteps: totalStep,
            currentStep: currentStep,
            stepSize: 2.5,
            selectedColor: AppColors.green1,
            unselectedColor: AppColors.darkGreen2,
            padding: 0,
            width: circleRadius * 2,
            height: circleRadius * 2,
            selectedStepSize: 2.5,
            roundedCap: (_, __) => true,
            child: Center(child: icon),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          title,
          style: titleStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2.0),
        Text(rate, style: rateStyle),
      ],
    );
  }
}
