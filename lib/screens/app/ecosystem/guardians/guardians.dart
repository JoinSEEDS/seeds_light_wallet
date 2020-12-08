import 'package:flutter/material.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/http_service.dart';

class Guardians extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlineButton(
            child: Text('Setup Guardians'),
            onPressed: () async {
              final currentPermissions =
                  await HttpService.of(context).getAccountPermissions();

              final ownerPermission = currentPermissions
                  .firstWhere((item) => item.permName == "owner");

              ownerPermission.requiredAuth.accounts.add({
                "weight": ownerPermission.requiredAuth.threshold,
                "permission": {
                  "actor": "guard.seeds",
                  "permission": "eosio.code"
                }
              });

              await EosService.of(context).updatePermission(
                ownerPermission,
              );
            }),
      ),
    );
  }
}
