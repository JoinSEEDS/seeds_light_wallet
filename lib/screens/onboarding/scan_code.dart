import 'package:flutter/material.dart';
import 'package:seeds/screens/onboarding/create_account.dart';
import 'package:seeds/screens/onboarding/onboarding.dart';
import 'package:seeds/widgets/seedsButton.dart';

import 'helpers.dart';

class ScanCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return isDebugMode()
        ? SeedsButton("Scan success - continue to create an account", () async {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => CreateAccount(debugInviteSecret),
            ));
          })
        : SeedsButton("Scan failed - back to choose another method", () async {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Onboarding()),
            );
          });
  }
}
