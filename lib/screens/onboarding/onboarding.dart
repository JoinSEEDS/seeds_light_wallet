import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/onboarding/onboarding_view_model.dart';

class Onboarding extends StatelessWidget {
  final List<PageViewModel> featurePages = [
    OnboardingViewModel.rich(
      bubble: null,
      mainImage: 'assets/images/onboarding1.png',
      body: [
        TextSpan(
          text: "Make payments globally without any fees. Earn rewards when you support 'regenerative' organisations and people.",
          style: TextStyle(fontWeight: FontWeight.bold)
        )
      ],
      title: 'Better than free transactions',
    ),
    OnboardingViewModel.rich(
      bubble: null,
      mainImage: 'assets/images/onboarding2.png',
      body: [
        //TextSpan(text: 'Heal our planet, grow the community and get rewarded for it.'),
        TextSpan(
          text: 'Vote directly on social and environmental impact projects you care about.', 
          style: TextStyle(fontWeight: FontWeight.bold)
        )
      ],
      title: 'Citizen Campaigns',
    ),
    OnboardingViewModel.rich(
      bubble: null,
      mainImage: 'assets/images/onboarding3.png',
      body: [
        TextSpan(
          text: 'Unite with a global movement of organisations and people to regenerate our planet and heal our economy.', 
          style: TextStyle(fontWeight: FontWeight.bold)
        )
      ],
      title: 'Regenerative Economy',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Container(
          color: AppColors.blue,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
          ),
        );
      },
    );
  }
}
