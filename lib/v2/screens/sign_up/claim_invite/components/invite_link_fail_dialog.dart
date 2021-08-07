import 'package:flutter/material.dart';
import 'package:seeds/i18n/security.i18n.dart';
import 'package:seeds/v2/components/custom_dialog.dart';
import 'package:seeds/v2/constants/app_colors.dart';

class InviteLinkFailDialog extends StatelessWidget {
  const InviteLinkFailDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: const Icon(Icons.cancel_outlined, size: 60, color: AppColors.red),
      children: [
        Text('Invite Code Error'.i18n, style: Theme.of(context).textTheme.headline6),
        const SizedBox(height: 24.0),
        Text(
          'This invite code has already been claimed! Please check with the person who invited you.'
              .i18n,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        const SizedBox(height: 16.0),
      ],
      singleLargeButtonTitle: 'Close'.i18n,
    );
  }
}
