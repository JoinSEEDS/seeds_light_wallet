import 'package:flutter/material.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/images/explore/vouch_white_background.dart';

class NotQualifiedToVouchDialog extends StatelessWidget {
  const NotQualifiedToVouchDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: const CustomPaint(
          size: Size(60, 60), painter: VouchWhiteBackground()),
      singleLargeButtonTitle: "Ok, Thank you!",
      children: [
        Text('Not qualified to Vouch!',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16.0),
        Text(
          'As a visitor you do not have permission to vouch for another member just yet. Please go through the steps to become a Resident or Citizen to vouch for others members!',
          style: Theme.of(context).textTheme.titleSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
