import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/i18n/authentication/verification/verification.i18n.dart';

class PasscodeCreatedDialog extends StatelessWidget {
  const PasscodeCreatedDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
      singleLargeButtonTitle: 'Close'.i18n,
      children: [
        Text('Succesful'.i18n, style: Theme.of(context).textTheme.button1),
        const SizedBox(height: 30.0),
        Text(
          'Pincode created successfully.'.i18n,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        const SizedBox(height: 30.0),
      ],
    );
  }
}
