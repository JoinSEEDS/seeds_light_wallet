import 'package:flutter/material.dart';
import 'package:seeds/screens/onboarding/onboarding.dart';
import 'package:seeds/widgets/seeds_button.dart';
import 'package:seeds/i18n/scan_code.i18n.dart';

class ScanCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SeedsButton("Scan failed - go back to choose another method".i18n, () async {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Onboarding()),
      );
    });
  }
}
