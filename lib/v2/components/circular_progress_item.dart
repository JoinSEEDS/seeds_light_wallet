import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/constants/app_colors.dart';

class CircularProgressItem extends StatelessWidget {
  final Widget icon;
  final int totalStep;
  final int currentStep;
  final String title;
  final String rate;

  const CircularProgressItem({
    Key key,
    @required this.icon,
    @required this.totalStep,
    @required this.currentStep,
    @required this.title,
    @required this.rate,
  })  : assert(icon != null),
        assert(totalStep != null),
        assert(currentStep != null),
        assert(title != null),
        assert(rate != null),
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
              width: 50,
              height: 50,
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
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.subtitle3,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Text(
              rate,
              style: Theme.of(context).textTheme.buttonHighEmphasis,
            ),
          ],
        ),
      ],
    );
  }
}
