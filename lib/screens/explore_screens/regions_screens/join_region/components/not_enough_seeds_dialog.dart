import 'package:flutter/material.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/app_constants.dart';
import 'package:seeds/images/explore/red_exclamation_circle.dart';
import 'package:seeds/utils/build_context_extension.dart';
import 'package:url_launcher/url_launcher.dart';

class NotEnoughSeedsDialog extends StatelessWidget {
  const NotEnoughSeedsDialog({super.key});

  Future<void> show(BuildContext context) async {
    return showDialog<void>(context: context, barrierDismissible: false, builder: (_) => this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: CustomDialog(
        icon: const CustomPaint(size: Size(60, 60), painter: RedExclamationCircle()),
        leftButtonTitle: context.loc.createRegionNotEnoughSeedsDialogLeftButtonTitle,
        rightButtonTitle: context.loc.createRegionNotEnoughSeedsDialogRightButtonTitle,
        onRightButtonPressed: () => launchUrl(Uri.parse('$urlBuySeeds${settingsStorage.accountName}')),
        children: [
          const SizedBox(height: 10.0),
          Text(context.loc.createRegionNotEnoughSeedsDialogTitle, style: Theme.of(context).textTheme.headline6),
          const SizedBox(height: 30.0),
          Text(
            context.loc.createRegionNotEnoughSeedsDialogSubtitle,
            style: Theme.of(context).textTheme.subtitle2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
