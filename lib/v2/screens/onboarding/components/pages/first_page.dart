import 'package:flutter/material.dart';
import 'package:seeds/v2/screens/onboarding/components/onboarding_pages.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OnboardingPage(
      onboardingImage: "assets/images/onboarding/onboarding5.png",
      topPadding: 30,
      title: "Better \nThan Free Transcations",
      subTitle:
          "Make payments globally without any fees. Earn rewards when you support ‘Regenerative’ organisations and people.",
      topLeaf1: Positioned(
        right: 80,
        top: -10,
        child: Image.asset(
          'assets/images/onboarding/small_light_right_leafe.png',
        ),
      ),
      bottomLeaf1: Positioned(
        bottom: -20,
        left: -30,
        child: Image.asset(
          'assets/images/onboarding/leafe_pointing_right.png',
        ),
      ),
      bottomLeaf2: Positioned(
        right: 50,
        top: 20,
        child: Image.asset(
          'assets/images/onboarding/leafe_pointing_left.png',
        ),
      ),
    );
  }
}
