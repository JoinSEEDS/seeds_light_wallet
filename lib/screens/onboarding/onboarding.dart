import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/onboarding/onboarding_view_model.dart';

class Onboarding extends StatelessWidget {
  final List<PageViewModel> featurePages = [
    OnboardingViewModel(
      bubble: Icons.account_balance_wallet,
      mainImage: 'assets/images/onboarding1.png',
      body:
          'Make global payments with zero fees - receive cashback for positive impact of your transactions',
      title: 'Better than free transactions',
    ),
    OnboardingViewModel(
      bubble: Icons.settings_backup_restore,
      mainImage: 'assets/images/onboarding2.png',
      body:
          'Plant Seeds for benefit of sustainable organizations - participate in harvest distribution',
      title: 'Plant Seeds - get Seeds',
    ),
    OnboardingViewModel(
      bubble: Icons.people,
      mainImage: 'assets/images/onboarding3.png',
      body:
          'Connect with other members and get funded for positive social and environmental contributions',
      title: 'Cooperative Economy',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Container(
          color: AppColors.darkBlue,
          child: SafeArea(
            child: IntroViewsFlutter(
              featurePages,
              onTapDoneButton: () async {
                NavigationService.of(context)
                  .navigateTo(Routes.onboardingMethodChoice);
                
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
          ),
        );
      },
    );
  }
}
