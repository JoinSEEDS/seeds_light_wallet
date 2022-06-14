import 'package:flutter/material.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/profile_screens/contribution/contribution_detail/components/contribution_detail_subtitle.dart';
import 'package:seeds/screens/profile_screens/contribution/interactor/viewmodels/page_commands.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ContributionDetailScreen extends StatelessWidget {
  const ContributionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.settings.arguments == null) {
      return Scaffold(appBar: AppBar(), body: const FullPageErrorIndicator());
    }

    final scoreDetails = ModalRoute.of(context)!.settings.arguments! as NavigateToScoreDetails;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("${scoreDetails.scoreType} Score"),
      ),
      bottomSheet: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Image.asset(
            'assets/images/contribution/contribution_detail/petals_left.png',
            width: width * 0.46,
            fit: BoxFit.fitWidth,
          ),
          const Spacer(),
          Image.asset('assets/images/contribution/contribution_detail/petals_right.png',
              width: width * 0.46, fit: BoxFit.fitWidth),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircularStepProgressIndicator(
              totalSteps: 99,
              currentStep: scoreDetails.score,
              stepSize: 2.5,
              selectedColor: AppColors.green1,
              unselectedColor: AppColors.darkGreen2,
              padding: 0,
              width: 220,
              height: 220,
              selectedStepSize: 6,
              roundedCap: (_, __) => true,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(scoreDetails.scoreType,
                        textAlign: TextAlign.center, maxLines: 2, style: Theme.of(context).textTheme.headline7),
                    const SizedBox(height: 8.0),
                    Text(scoreDetails.score.toString(), style: Theme.of(context).textTheme.headline3),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
              child: Text(
                scoreDetails.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline7,
              ),
            ),
            const SizedBox(height: 40),
            ContributionDetailSubtitle(scoreDetails.subtitle),
            SizedBox(height: width * 0.6),
          ],
        ),
      ),
    );
  }
}
