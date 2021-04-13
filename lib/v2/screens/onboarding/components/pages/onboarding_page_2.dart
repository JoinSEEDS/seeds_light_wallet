import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/v2/constants/app_colors.dart';
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
        child: SvgPicture.asset(
          'assets/images/onboarding/leaves/pointing_left/medium_light_leaf.svg',
        ),
      ),
      bottomLeaf1: Positioned(
        bottom: 70,
        left: 50,
        child: SvgPicture.asset(
          'assets/images/onboarding/leaves/pointing_right/small_light_leaf.svg',
          color: AppColors.lightGreen1,
        ),
      ),
      bottomLeaf2: Positioned(
        right: 60,
        top: 60,
        child: SvgPicture.asset(
          'assets/images/onboarding/leaves/pointing_left/medium_dark_leaf.svg',
        ),
      ),
    );
  }
}
