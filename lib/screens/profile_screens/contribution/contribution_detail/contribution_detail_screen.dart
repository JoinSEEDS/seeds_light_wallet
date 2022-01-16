import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/screens/profile_screens/contribution/contribution_detail/components/contribution_detail_subtitle.dart';
import 'package:seeds/screens/profile_screens/contribution/interactor/viewmodels/page_commands.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ContributionDetailScreen extends StatelessWidget {
  const ContributionDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scoreDetails = ModalRoute.of(context)?.settings.arguments as NavigateToScoreDetails?;

    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          Text(scoreDetails?.scoreType ?? ""),
          const Text(' Score'),
        ],
      )),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircularStepProgressIndicator(
                  totalSteps: 99,
                  currentStep: scoreDetails?.score ?? 0,
                  stepSize: 2.5,
                  selectedColor: AppColors.green1,
                  unselectedColor: AppColors.darkGreen2,
                  padding: 0,
                  width: 200,
                  height: 200,
                  selectedStepSize: 2.5,
                  roundedCap: (_, __) => true,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(scoreDetails?.scoreType ?? '',
                            textAlign: TextAlign.center, maxLines: 2, style: Theme.of(context).textTheme.headline7),
                        const SizedBox(height: 8.0),
                        Text(scoreDetails?.score.toString() ?? '0', style: Theme.of(context).textTheme.headline3),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(scoreDetails?.title ?? ''),
                const SizedBox(height: 30),
                ContributionDetailSubtitle(title: scoreDetails?.subtitle ?? ''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
