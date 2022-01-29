import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/constants/app_colors.dart';

class InviteLinkFailDialog extends StatelessWidget {
  const InviteLinkFailDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return CustomDialog(
      icon: const Icon(Icons.cancel_outlined, size: 60, color: AppColors.red),
      singleLargeButtonTitle: localization.signUpCloseButtonTitle,
      children: [
        Text(localization.signUpInviteCodeErrorTitle, style: Theme.of(context).textTheme.headline6),
        const SizedBox(height: 24.0),
        Text(
          localization.signUpInviteCodeErrorDescription,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
