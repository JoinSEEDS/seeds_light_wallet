import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:seeds/constants/custom_colors.dart';

import 'create_account.dart';
import 'helpers.dart';
import 'onboarding_method_choice.dart';

class Onboarding extends StatelessWidget {
  final List<PageViewModel> featurePages = [
    page(
      bubble: Icons.account_balance_wallet,
      mainImage: 'assets/images/onboarding1.png',
      body:
          'Make global payments with zero fees - receive cashback for positive impact of your transactions',
      title: 'Better than free transactions',
    ),
    page(
        bubble: Icons.settings_backup_restore,
        mainImage: 'assets/images/onboarding2.png',
        body:
            'Plant Seeds for benefit of sustainable organizations - participate in harvest distribution',
        title: 'Plant Seeds - get Seeds'),
    page(
        bubble: Icons.people,
        mainImage: 'assets/images/onboarding3.png',
        body:
            'Connect with other members and get funded for positive social and environmental contributions',
        title: 'Cooperative Economy'),
  ];

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Container(
        color: CustomColors.DarkBlue,
        child: SafeArea(
                child: IntroViewsFlutter(
            featurePages,
            key: new UniqueKey(),
            onTapDoneButton: () async {
              if (isDebugMode() && debugInviteSecret != "") {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => CreateAccount(debugInviteSecret),
                  ),
                );

                return;
              }

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => OnboardingMethodChoice(),
                ),
              );
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
      ),
    );
  }
}
