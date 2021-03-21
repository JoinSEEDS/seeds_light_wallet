import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import '../onboarding_pages.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OnboardingPage(
      onboardingImage: "assets/images/onboarding/onboarding1.png",
      topPadding: 50,
      title: "Citizen Campaigns",
      subTitle: "Participate and vote directly on social and environmental impact projects you care about.",
      topLeaf1: Positioned(
        left: 40,
        top: 40,
        child: Image.asset(
          'assets/images/onboarding/medium_light_left_leafe.png',
        ),
      ),
      bottomLeaf1: Positioned(
        bottom: 70,
        left: 50,
        child: Image.asset(
          'assets/images/onboarding/small_light_right_leafe.png',
          color: AppColors.lightGreen1,
        ),
      ),
      bottomLeaf2: Positioned(
        right: 60,
        top: 60,
        child: Image.asset(
          'assets/images/onboarding/medium_dark_left_leafe.png',
        ),
      ),
    );
  }
}
