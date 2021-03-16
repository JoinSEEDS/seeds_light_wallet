import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:seeds/constants/app_colors.dart';

class CircularProgressItem extends StatelessWidget {
  final Widget icon;
  final int totalStep;
  final int currentStep;
  final double circleRadius;
  final String title;
  final TextStyle titleStyle;
  final String rate;
  final TextStyle rateStyle;

  const CircularProgressItem({
    Key key,
    @required this.icon,
    @required this.totalStep,
    @required this.currentStep,
    @required this.circleRadius,
    @required this.title,
    @required this.titleStyle,
    @required this.rate,
    @required this.rateStyle,
  })  : assert(icon != null),
        assert(totalStep != null),
        assert(currentStep != null),
        assert(circleRadius != null),
        assert(title != null),
        assert(titleStyle != null),
        assert(rate != null),
        assert(rateStyle != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircularStepProgressIndicator(
              circularDirection: CircularDirection.counterclockwise,
              totalSteps: totalStep,
              currentStep: currentStep,
              stepSize: 2.5,
              selectedColor: AppColors.primary,
              unselectedColor: AppColors.green1,
              padding: 0,
              width: circleRadius * 2,
              height: circleRadius * 2,
              selectedStepSize: 2.5,
              roundedCap: (_, __) => true,
              child: Center(child: icon),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 100),
                child: Text(title, textAlign: TextAlign.center, maxLines: 2, style: titleStyle),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(children: [Text(rate, style: rateStyle)]),
      ],
    );
  }
}
