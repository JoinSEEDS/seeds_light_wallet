import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/design/app_theme.dart';

class FlagUserInfoDialog extends StatelessWidget {
  const FlagUserInfoDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return CustomDialog(
      icon: SvgPicture.asset("assets/images/profile/logout_icon.svg"),
      children: [
        Text(localization.explorerFlagInfoDialogTitle, style: Theme.of(context).textTheme.button1),
        const SizedBox(height: 30.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Text(
                localization.explorerFlagInfoDialogSubTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              const SizedBox(height: 36.0),
              Text(
                localization.explorerFlagInfoDialogSubTitlePartTwo,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              const SizedBox(height: 36.0),
              FlatButtonLong(
                title: localization.explorerFlagInfoDialogButtonTitle,
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
