import 'package:flutter/material.dart';

class Guardians extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlineButton(
          child: Text('Setup Guardians'),
          onTap: () async {
            final currentPermissions = await HttpService.of(context).getAccountPermissions();

            await EosService.of(context).setupGuardianPermission(1, "accountName", currentPermissions);
          }
        ),
      ),
    );
  }
}
