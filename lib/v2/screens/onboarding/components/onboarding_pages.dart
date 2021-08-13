import 'package:flutter/material.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/i18n/onboarding.i18n.dart';

class OnboardingPage extends StatelessWidget {
  final String onboardingImage;
  final String title;
  final String subTitle;
  final double topPadding;
  final Widget topLeaf1;
  final Widget? topLeaf2;
  final Widget bottomLeaf1;
  final Widget bottomLeaf2;

  const OnboardingPage({
    Key? key,
    required this.onboardingImage,
    required this.title,
    required this.subTitle,
    required this.topPadding,
    required this.topLeaf1,
    required this.bottomLeaf1,
    required this.bottomLeaf2,
    this.topLeaf2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.lightGreen4,
              borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(300, 50)),
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(bottom: 20, top: 90, right: 40, left: 40),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    topLeaf1,
                    topLeaf2 ?? const SizedBox.shrink(),
                    Image.asset(onboardingImage),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: topPadding),
        Expanded(
          flex: 2,
          child: Container(
            height: 310,
            padding: const EdgeInsets.only(right: 40, left: 40),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  bottomLeaf1,
                  bottomLeaf2,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title.i18n, style: Theme.of(context).textTheme.headline3),
                      const SizedBox(height: 30),
                      Text(subTitle.i18n, style: Theme.of(context).textTheme.button),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
