import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/i18n/passcode.i18n.dart';
import 'package:seeds/v2/components/custom_dialog.dart';

class PasscodeCreatedDialog extends StatelessWidget {
  const PasscodeCreatedDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
      children: [
        Text('Succesful'.i18n, style: Theme.of(context).textTheme.button1Black),
        const SizedBox(height: 30.0),
        Text(
          'Pincode created successfully.'.i18n,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle2Darkgreen1L,
        ),
        const SizedBox(height: 30.0),
      ],
      singleLargeButtonTitle: 'Close'.i18n,
    );
  }
}
