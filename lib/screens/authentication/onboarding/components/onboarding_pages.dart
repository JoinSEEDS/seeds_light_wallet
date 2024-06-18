import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';

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
    super.key,
    required this.onboardingImage,
    required this.title,
    required this.subTitle,
    required this.topPadding,
    required this.topLeaf1,
    required this.bottomLeaf1,
    required this.bottomLeaf2,
    this.topLeaf2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 2,
          decoration: const BoxDecoration(
            color: AppColors.lightGreen4,
            borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(300, 50)),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(bottom: 20, top: 50, right: 40, left: 40),
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
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(right: 40, left: 40, bottom: 20),
            child: Center(
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
                        Text(title, style: Theme.of(context).textTheme.displaySmall),
                        const SizedBox(height: 30),
                        Text(subTitle, style: Theme.of(context).textTheme.labelLarge),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
