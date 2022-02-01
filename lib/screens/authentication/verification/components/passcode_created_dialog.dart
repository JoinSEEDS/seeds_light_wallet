import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/design/app_theme.dart';

class PasscodeCreatedDialog extends StatelessWidget {
  const PasscodeCreatedDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return CustomDialog(
      icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
      singleLargeButtonTitle: localization.verificationPasscodeDialogButtonTitle,
      children: [
        Text(localization.verificationPasscodeDialogTitle, style: Theme.of(context).textTheme.button1),
        const SizedBox(height: 30.0),
        Text(
          localization.verificationPasscodeDialogSubTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        const SizedBox(height: 30.0),
      ],
    );
  }
}
