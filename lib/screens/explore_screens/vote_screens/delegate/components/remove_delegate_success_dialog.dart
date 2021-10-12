import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/components/custom_dialog.dart';

class RemoveDelegateSuccessDialog extends StatelessWidget {
  const RemoveDelegateSuccessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        return true;
      },
      child: CustomDialog(
        icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
        singleLargeButtonTitle: "Dismiss",
        onSingleLargeButtonPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Delegate removal Success', style: Theme.of(context).textTheme.headline6),
            ],
          ),
          const SizedBox(height: 30.0),
        ],
      ),
    );
  }
}
