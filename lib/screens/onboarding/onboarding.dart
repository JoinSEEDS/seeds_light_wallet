import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/onboarding/onboarding_view_model.dart';
import 'package:seeds/i18n/onboarding.i18n.dart';

class Onboarding extends StatelessWidget {
  final List<PageViewModel> featurePages = [
    OnboardingViewModel.rich(
      bubble: null,
      mainImage: 'assets/images/onboarding/onboarding1.png',
      body: [
        TextSpan(
          text: "Make payments globally without any fees. Earn rewards when you support 'regenerative' organisations and people.".i18n,
          style: TextStyle(fontWeight: FontWeight.bold)
        )
      ],
      title: 'Better than free transactions'.i18n,
    ),
    OnboardingViewModel.rich(
      bubble: null,
      mainImage: 'assets/images/onboarding/onboarding2.png',
      body: [
        //TextSpan(text: 'Heal our planet, grow the community and get rewarded for it.'),
        TextSpan(
          text: 'Vote directly on social and environmental impact projects you care about.'.i18n, 
          style: TextStyle(fontWeight: FontWeight.bold)
        )
      ],
      title: 'Citizen Campaigns'.i18n,
    ),
    OnboardingViewModel.rich(
      bubble: null,
      mainImage: 'assets/images/onboarding/onboarding3.png',
      body: [
        TextSpan(
          text: 'Unite with a global movement of organisations and people to regenerate our planet and heal our economy.'.i18n, 
          style: TextStyle(fontWeight: FontWeight.bold)
        )
      ],
      title: 'Regenerative Economy'.i18n,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Container(
          color: AppColors.blue,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: IntroViewsFlutter(
              featurePages,
              onTapDoneButton: () async {
                NavigationService.of(context)
                    // .navigateTo(Routes.joinProcess, null, true);
                .navigateTo(Routes.login, null, true);
              },
              doneButtonPersist: true,
              nextText: Text("NEXT".i18n),
              backText: Text("BACK".i18n),
              doneText: Text(
                "JOIN NOW".i18n,
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
