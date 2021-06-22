import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:seeds/v2/components/custom_dialog.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';

class OnboardingDialogDoubleAction extends StatelessWidget {
  final int indexDialong;
  final String image;
  final String description;
  final GestureTapCallback? onLeftButtonTab;
  final GestureTapCallback? onRightButtonTab;
  final String leftButtonTitle;
  final String rightButtonTitle;

  const OnboardingDialogDoubleAction(
      {Key? key,
      required this.indexDialong,
      required this.image,
      required this.description,
      this.onRightButtonTab,
      this.onLeftButtonTab,
      required this.rightButtonTitle,
      required this.leftButtonTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: CustomDialog(
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
              decorator: const DotsDecorator(
                spacing: EdgeInsets.all(2.0),
                size: Size(10.0, 2.0),
                shape: Border(),
                color: AppColors.grey3,
                activeColor: AppColors.green1,
                activeSize: Size(18.0, 2.0),
                activeShape: Border(),
              ),
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
          rightButtonTitle: rightButtonTitle,
          onRightButtonPressed: onRightButtonTab,
          leftButtonTitle: leftButtonTitle,
          onLeftButtonPressed: onLeftButtonTab,
        ),
      ),
    );
  }
}
