import 'package:flutter/material.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/components/dots_indicator.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/domain-shared/ui_constants.dart';

class OnboardingDialogSingleAction extends StatelessWidget {
  final int indexDialong;
  final String image;
  final String description;
  final GestureTapCallback? onNext;
  final String buttonTitle;
  const OnboardingDialogSingleAction(
      {super.key,
      required this.indexDialong,
      required this.image,
      required this.description,
      this.onNext,
      required this.buttonTitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: CustomDialog(
          singleLargeButtonTitle: buttonTitle,
          onSingleLargeButtonPressed: onNext,
          children: [
            Container(
              height: 200,
              width: 250,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.all(Radius.circular(defaultCardBorderRadius)),
                image: DecorationImage(image: AssetImage(image), fit: BoxFit.fitWidth),
              ),
            ),
            const SizedBox(height: 20),
            DotsIndicator(
              dotsCount: 4,
              position: indexDialong.toDouble() - 1,
              decorator: DotsDecorator.copyWith(color: AppColors.grey3),
            ),
            const SizedBox(height: 30),
            Container(
              height: 130,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                description,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
