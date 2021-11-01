import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/i18n/onboarding/onboarding.i18n.dart';

import '../onboarding_pages.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnboardingPage(
      onboardingImage: "assets/images/onboarding/onboarding3.png",
      topPadding: 50,
      title: "Regenerative\nEconomy".i18n,
      subTitle:
          "Unite with a global movement of\norganizations and people to regenerate our\nplanet and heal our economy."
              .i18n,
      topLeaf1: Positioned(
        right: -20,
        top: -90,
        child: SvgPicture.asset(
          'assets/images/onboarding/leaves/pointing_right/big_light_leaf.svg',
          color: AppColors.lightGreen3,
        ),
      ),
      bottomLeaf1: Positioned(
        right: 100,
        bottom: 90,
        child: SvgPicture.asset('assets/images/onboarding/leaves/pointing_left/small_light_leaf.svg'),
      ),
      bottomLeaf2: Positioned(
        left: 30,
        top: 20,
        child: SvgPicture.asset('assets/images/onboarding/leaves/pointing_left/medium_dark_leaf.svg'),
      ),
    );
  }
}
