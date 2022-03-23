import 'package:flutter/material.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/images/explore/red_exclamation_circle.dart';
import 'package:seeds/utils/build_context_extension.dart';

class NotEnoughSeedsDialog extends StatelessWidget {
  const NotEnoughSeedsDialog({Key? key}) : super(key: key);

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
        onRightButtonPressed: () {},
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
