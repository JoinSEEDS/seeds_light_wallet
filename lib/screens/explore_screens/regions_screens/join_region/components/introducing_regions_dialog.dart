import 'package:flutter/material.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/images/explore/regions.dart';
import 'package:seeds/utils/build_context_extension.dart';

class IntroducingRegionsDialog extends StatelessWidget {
  const IntroducingRegionsDialog({Key? key}) : super(key: key);

  Future<bool?> show(BuildContext context) async {
    return showDialog(barrierDismissible: false, context: context, builder: (_) => this);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: CustomDialog(
          leftButtonTitle: context.loc.genericCancelButtonTitle,
          rightButtonTitle: context.loc.genericNextButtonTitle,
          onRightButtonPressed: () {
            settingsStorage.isFirstTimeOnRegionsScreen = false;
            Navigator.of(context).pop(true);
          },
          children: [
            Text(context.loc.introducingRegionsDialogTitle, style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 30.0),
            const CustomPaint(size: Size(103, 106), painter: Regions()),
            const SizedBox(height: 40.0),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: context.loc.introducingRegionsDialogDescription1, style: Theme.of(context).textTheme.subtitle2),
                  TextSpan(
                      text: context.loc.introducingRegionsDialogDescription2,
                      style: Theme.of(context).textTheme.subtitle2HighEmphasis),
                  TextSpan(
                      text: context.loc.introducingRegionsDialogDescription3, style: Theme.of(context).textTheme.subtitle2),
                  TextSpan(
                      text: context.loc.introducingRegionsDialogDescription4, style: Theme.of(context).textTheme.subtitle2),
                  TextSpan(
                      text: context.loc.introducingRegionsDialogDescription5,
                      style: Theme.of(context).textTheme.subtitle2Green2),
                  TextSpan(
                      text: context.loc.introducingRegionsDialogDescription6, style: Theme.of(context).textTheme.subtitle2),
                  TextSpan(
                      text: context.loc.introducingRegionsDialogDescription7, style: Theme.of(context).textTheme.subtitle2),
                  TextSpan(
                      text: ' ${context.loc.genericNextButtonTitle} ', style: Theme.of(context).textTheme.subtitle2Green2),
                  TextSpan(
                      text: context.loc.introducingRegionsDialogDescription8, style: Theme.of(context).textTheme.subtitle2),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
