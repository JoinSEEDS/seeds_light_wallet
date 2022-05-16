import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/i18n/explore_screens/vote/proposals/proposals_details.i18n.dart';

class VoteSuccessDialog extends StatelessWidget {
  const VoteSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
      singleLargeButtonTitle: 'Done'.i18n,
      children: [
        Text('Thank you!'.i18n, style: Theme.of(context).textTheme.button1),
        const SizedBox(height: 24.0),
        Text(
          'Thank you for coming and contributing your voice to the collective decision making process. Please make sure to come back at the start of the next Voting Cycle to empower more people!'
              .i18n,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
