import 'package:flutter/material.dart';
import 'package:seeds/components/custom_dialog.dart';

class IntroducingDelegatesDialog extends StatelessWidget {
  const IntroducingDelegatesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: CustomDialog(
        singleLargeButtonTitle: "Dismiss",
        onSingleLargeButtonPressed: () => Navigator.of(context).pop(),
        children: [
          Text('Introducing Delegates!', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 30.0),
          Image.asset('assets/images/explore/introducing_delegate.png'),
          const SizedBox(height: 30.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'You may now select another Citizen of the Seeds-verse to represent you and vote on your behalf. ',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30.0)
        ],
      ),
    );
  }
}
