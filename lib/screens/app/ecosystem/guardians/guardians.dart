

import 'package:flutter/material.dart';
import 'package:seeds/constants/http_mock_response.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/providers/services/http_service.dart';

// loading only once - refresh manually - because only here the state can be changed
enum Status {
  init,
  loading, // show progress bar when first time trying to figure out the status or refresh clicked by user
  noPermission, // show button to send transaction with confirmation to update account permission
  noGuardians,
  // show link to share to guardians and list of guardians agreed - then
  // when 3 guardians chosen - then button to approve them
  inRecovery, // allow to cancel
  safe // has guardians - show list of guardians
}

bool? hasGuardianPermission;
bool? hasGuardiansInitialized;
bool? inRecoveryProcess;

class Guardians extends StatefulWidget {
  @override
  _GuardiansState createState() => _GuardiansState();
}

class _GuardiansState extends State<Guardians> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          OutlineButton(
            child: Text('Setup Permission'),
            onPressed: () => setupPermission(),
          ),
          OutlineButton(
            child: Text('Init Guardians'),
            onPressed: () => initGuardians(),
          ),
          OutlineButton(child: Text('Recover Account'), onPressed: () => recoverAccount()),
          OutlineButton(
            child: Text('Cancel Recovery'),
            onPressed: () => cancelRecovery(),
          ),
          OutlineButton(
            child: Text('Claim Account'),
            onPressed: () => claimAccount(),
          ),
        ],
      ),
    );
  }

  void claimAccount() {
    String userAccount = "";

    EosService.of(context).claimRecoveredAccount(userAccount);
  }

  void recoverAccount() {
    String? userAccount = HttpMockResponse.members[4].account;
    String publicKey = "";

    EosService.of(context)
        .recoverAccount(userAccount, publicKey)
        .then((value) => FirebaseDatabaseService().setGuardianRecoveryStarted(userAccount));
  }

  void cancelRecovery() {
    EosService.of(context).cancelRecovery();
  }

  void initGuardians() {
    List<String?> guardians = [
      HttpMockResponse.members[0].account,
      HttpMockResponse.members[1].account,
      HttpMockResponse.members[2].account
    ];

    EosService.of(context).initGuardians(guardians);
  }

  void setupPermission() async {
    final currentPermissions = await (HttpService.of(context).getAccountPermissions());

    final ownerPermission = currentPermissions!.firstWhere((item) => item.permName == "owner");

    ownerPermission.requiredAuth!.accounts!.add({
      "weight": ownerPermission.requiredAuth!.threshold,
      "permission": {"actor": "guard.seeds", "permission": "eosio.code"}
    });

    await EosService.of(context).updatePermission(ownerPermission);
  }
}
