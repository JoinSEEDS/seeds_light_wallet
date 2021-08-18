import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/design/app_theme.dart';

class ConfirmVoteDialog extends StatelessWidget {
  const ConfirmVoteDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
      leftButtonTitle: 'Cancel',
      onLeftButtonPressed: () => Navigator.of(context).pop(),
      rightButtonTitle: 'Confirm',
      onRightButtonPressed: () => Navigator.of(context).pop(true),
      children: [
        Text('Confirm your Vote', style: Theme.of(context).textTheme.button1),
        const SizedBox(height: 24.0),
        Text(
          'Your trust tokens cannot be reallocated afterwards so please be sure of your vote!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
