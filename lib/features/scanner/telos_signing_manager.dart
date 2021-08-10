// ignore: import_of_legacy_library_into_null_safe
import 'package:dart_esr/dart_esr.dart';

class SeedsESR {
  late SigningRequestManager manager;

  late List<Action> actions;

  SeedsESR({String? uri}) {
    manager = TelosSigningManager.from(uri);
  }

  Future<void> resolve({String? account}) async {
    actions = await manager.fetchActions(account: account);
  }
}

extension TelosSigningManager on SigningRequestManager {
  static SigningRequestManager from(String? uri) {
    return SigningRequestManager.from(uri,
        options: defaultSigningRequestEncodingOptions(nodeUrl: 'https://api.eos.miami'));
  }

  Future<List<Action>> fetchActions({String? account, String permission = "active"}) async {
    var abis = await fetchAbis();

    var auth = Authorization();
    auth.actor = account;
    auth.permission = permission;

    var actions = resolveActions(abis, auth);

    return actions;
  }
}
