import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/i18n/explore_screens/vote/proposals/proposals_details.i18n.dart';

class ConfirmVoteDialog extends StatelessWidget {
  const ConfirmVoteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
      leftButtonTitle: 'Cancel'.i18n,
      rightButtonTitle: 'Confirm'.i18n,
      onRightButtonPressed: () => Navigator.of(context).pop(true),
      children: [
        Text('Confirm your Vote'.i18n, style: Theme.of(context).textTheme.button1),
        const SizedBox(height: 24.0),
        Text(
          'Your trust tokens cannot be reallocated afterwards so please be sure of your vote!'.i18n,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
