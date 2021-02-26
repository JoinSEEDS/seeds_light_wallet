import 'package:flutter/material.dart';
import 'package:seeds/v2/components/flat_button_long.dart';

/// Login SCREEN
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlatButtonLong(
          onPressed: () {

          },
          title: "Claim invite code",
        ),
        FlatButtonLong(
          onPressed: () {

          },
          title: "Import private key",
        )
      ],
    );
  }
}
