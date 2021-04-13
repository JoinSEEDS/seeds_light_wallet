// @dart=2.9

import 'package:dart_esr/dart_esr.dart';

class SeedsESR {

  SigningRequestManager manager;

  List<Action> actions;

  SeedsESR({String uri}) {
    manager = TelosSigningManager.from(uri);
  }

  Future<void> resolve({String account}) async {
    this.actions = await manager.fetchActions(account: account);
  }

}

extension TelosSigningManager on SigningRequestManager {
    static SigningRequestManager from(String uri) {
      return SigningRequestManager.from(uri,
      options:
          defaultSigningRequestEncodingOptions(nodeUrl: 'https://api.eos.miami'));
    }

    Future<List<Action>> fetchActions({String account, String permission = "active"}) async {

      var abis = await fetchAbis();

      var auth = Authorization();
      auth.actor = account;
      auth.permission = permission;

      var actions = resolveActions(abis, auth);

      return actions;
    }
}