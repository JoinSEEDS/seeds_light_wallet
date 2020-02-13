import 'package:flutter/material.dart';
import 'package:seeds/screens/onboarding/onboarding.dart';
import 'package:seeds/widgets/seeds_button.dart';

class ScanCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SeedsButton("Scan failed - back to choose another method", () async {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Onboarding()),
      );
    });
  }
}
