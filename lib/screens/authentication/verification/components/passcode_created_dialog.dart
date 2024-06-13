import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/utils/build_context_extension.dart';

class PasscodeCreatedDialog extends StatelessWidget {
  const PasscodeCreatedDialog({super.key});

  Future<void> show(BuildContext context) async {
    return showDialog<void>(
        context: context, barrierDismissible: false, builder: (_) => this);
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon:
          SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
      singleLargeButtonTitle: context.loc.genericCloseButtonTitle,
      children: [
        Text(context.loc.verificationPasscodeDialogTitle,
            style: Theme.of(context).textTheme.button1),
        const SizedBox(height: 30.0),
        Text(
          context.loc.verificationPasscodeDialogSubTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 30.0),
      ],
    );
  }
}
