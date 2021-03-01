import 'package:flutter/material.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/v2/components/flat_button_long.dart';

/// Login SCREEN
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButtonLong(
              onPressed: () {},
              title: "Claim invite code",
            ),
            FlatButtonLong(
              onPressed: () {
                NavigationService.of(context).navigateTo(Routes.importKey);
              },
              title: "Import private key",
            )
          ],
        ));
  }
}
