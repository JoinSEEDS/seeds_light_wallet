import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/screens/authentication/onboarding/components/onboarding_pages.dart';
import 'package:seeds/utils/build_context_extension.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingPage(
      onboardingImage: "assets/images/onboarding/onboarding1.png",
      topPadding: 50,
      title: context.loc.onboardingCampaignsTitle,
      subTitle: context.loc.onboardingCampaignsSubtitle,
      topLeaf1: Positioned(
        left: 40,
        top: 40,
        child: SvgPicture.asset('assets/images/onboarding/leaves/pointing_left/medium_light_leaf.svg'),
      ),
      bottomLeaf1: Positioned(
        bottom: 0,
        left: 50,
        child: SvgPicture.asset(
          'assets/images/onboarding/leaves/pointing_right/small_light_leaf.svg',
          color: AppColors.lightGreen1,
        ),
      ),
      bottomLeaf2: Positioned(
        right: 60,
        top: 0,
        child: SvgPicture.asset('assets/images/onboarding/leaves/pointing_left/medium_dark_leaf.svg'),
      ),
    );
  }
}
