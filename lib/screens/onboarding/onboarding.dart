import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/onboarding/onboarding_view_model.dart';

class Onboarding extends StatelessWidget {
  final List<PageViewModel> featurePages = [
    OnboardingViewModel(
      bubble: null,
      mainImage: 'assets/images/onboarding1.png',
      body:
        "Make global payments with zero fees. Earn rewards when you support 'regenerative' organisations and people.",
      title: 'Better than free transactions',
    ),
    OnboardingViewModel(
      bubble: null,
      mainImage: 'assets/images/onboarding2.png',
      body:
        'Earn rewards for participating in campaigns for direct social, community and environmental regeneration. Get paid to heal our planet and grow community.',
      title: 'Citizen Campaigns',
    ),
    OnboardingViewModel(
      bubble: null,
      mainImage: 'assets/images/onboarding3.png',
      body:
        'Unite with a global movement of organisations and people to heal our planet. Access funding for social and environmental impact projects.',
      title: 'Regenerative Economy',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Container(
          color: AppColors.darkBlue,
          child: IntroViewsFlutter(
            featurePages,
            onTapDoneButton: () async {
              NavigationService.of(context)
                  .navigateTo(Routes.joinProcess, null, true);
            },
            doneButtonPersist: true,
            doneText: Text(
              "JOIN NOW",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "worksans",
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            showSkipButton: false,
            showNextButton: true,
            showBackButton: true,
            pageButtonTextStyles: TextStyle(
              fontFamily: "worksans",
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      },
    );
  }
}
