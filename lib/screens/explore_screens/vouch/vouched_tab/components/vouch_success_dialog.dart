import 'package:flutter/material.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/images/explore/vouch_white_background.dart';

class VouchSuccessDialog extends StatelessWidget {
  const VouchSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: const CustomPaint(size: Size(60, 60), painter: VouchWhiteBackground()),
      singleLargeButtonTitle: "Close",
      children: [
        const SizedBox(height: 10.0),
        Text('Successfully Vouched!', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
