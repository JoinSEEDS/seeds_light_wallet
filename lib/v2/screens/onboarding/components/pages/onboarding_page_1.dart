import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/v2/screens/onboarding/components/onboarding_pages.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OnboardingPage(
      onboardingImage: "assets/images/onboarding/onboarding5.png",
      topPadding: 30,
      title: "Better \nThan Free Transactions",
      subTitle:
          "Make payments globally without any fees. Earn rewards when you support ‘Regenerative’ organizations and people.",
      topLeaf1: Positioned(
        right: 80,
        top: -10,
        child: SvgPicture.asset('assets/images/onboarding/leaves/pointing_right/small_light_leaf.svg'),
      ),
      bottomLeaf1: Positioned(
        bottom: -20,
        left: -30,
        child: SvgPicture.asset(
          'assets/images/onboarding/leaves/pointing_right/big_dark_leaf.svg',
        ),
      ),
      bottomLeaf2: Positioned(
        right: 50,
        top: 20,
        child: SvgPicture.asset(
          'assets/images/onboarding/leaves/pointing_left/small_light_leaf.svg',
        ),
      ),
    );
  }
}
