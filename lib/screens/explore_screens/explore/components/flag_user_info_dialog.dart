import 'package:flutter/material.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/images/explore/red_exclamation_circle.dart';
import 'package:seeds/utils/build_context_extension.dart';

class FlagUserInfoDialog extends StatelessWidget {
  const FlagUserInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: const CustomPaint(size: Size(60, 60), painter: RedExclamationCircle()),
      children: [
        Text(context.loc.explorerFlagInfoDialogTitle, style: Theme.of(context).textTheme.button1),
        const SizedBox(height: 30.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Text(
                context.loc.explorerFlagInfoDialogSubTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              const SizedBox(height: 36.0),
              Text(
                context.loc.explorerFlagInfoDialogSubTitlePartTwo,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              const SizedBox(height: 36.0),
              FlatButtonLong(
                title: context.loc.explorerFlagInfoDialogButtonTitle,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ],
    );
  }
}
