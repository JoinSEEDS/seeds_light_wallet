import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/utils/build_context_extension.dart';

class ConfirmVoteDialog extends StatelessWidget {
  const ConfirmVoteDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
      leftButtonTitle: context.loc.genericCancelButtonTitle,
      rightButtonTitle: context.loc.genericConfirmButtonTitle,
      onRightButtonPressed: () => Navigator.of(context).pop(true),
      children: [
        Text(context.loc.proposalDetailsConfirmVoteTitle, style: Theme.of(context).textTheme.button1),
        const SizedBox(height: 24.0),
        Text(
          context.loc.proposalDetailsConfirmVoteDescription,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
