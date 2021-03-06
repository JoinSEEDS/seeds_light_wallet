import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/v2/components/custom_dialog.dart';
import 'package:seeds/v2/design/app_theme.dart';

class VoteSuccessDialog extends StatelessWidget {
  const VoteSuccessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
      children: [
        Text('Thank you!', style: Theme.of(context).textTheme.button1),
        const SizedBox(height: 24.0),
        Text(
          'Thank you for coming and contributing your voice to the collective decision making process. Please make sure to come back at the start of the next Voting Cycle to empower more people!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        const SizedBox(height: 16.0),
      ],
      singleLargeButtonTitle: 'Done',
    );
  }
}
