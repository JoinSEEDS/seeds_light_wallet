import 'package:flutter/material.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/domain-shared/ui_constants.dart';

class GuardianDialogSingleAction extends StatelessWidget {
  final String image;
  final String description;
  final GestureTapCallback? onButtonTab;
  final String buttonTitle;
  final String title;
  const GuardianDialogSingleAction(
      {super.key,
      required this.image,
      required this.description,
      this.onButtonTab,
      required this.buttonTitle,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: CustomDialog(
          singleLargeButtonTitle: buttonTitle,
          onSingleLargeButtonPressed: onButtonTab,
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
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(description, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
