import 'package:async/async.dart';
import 'package:seeds/crypto/dart_esr/dart_esr.dart';
import 'package:seeds/datasource/local/models/eos_transaction.dart';
import 'package:seeds/datasource/local/models/scan_qr_code_result_data.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';

class SeedsESR {
  late SigningRequestManager manager;

  late List<Action> actions;

  String? get callback => manager.signingRequest.callback;

  SeedsESR({String? uri}) {
    manager = TelosSigningManager.from(uri);
  }

  Future<void> resolve({String? account}) async {
    actions = await manager.fetchActions(account: account);
  }

  // TODO(n13): Remove this method and replace it with something more sensible. This is using the already resolved
  // ESR object and creating a lightweight action data object out of the first action, so be passed around to
  // other components.
  // Better ways to do that
  // Pass around the whole ESR object, or an Action object.
  // instead of canProcess, have an isValid accessor on the ESR and handle this case in the mappers.
  Result processResolvedRequest() {
    final EOSTransaction eosTransaction = EOSTransaction.fromActionsList(actions);
    if (eosTransaction.isValid) {
      print("processResolvedRequest: Success QR");
      return ValueResult(ScanQrCodeResultData(transaction: eosTransaction, esr: this));
    } else {
      print("processResolvedRequest: ESR transaction invalid ${actions.length} $actions");
      return ErrorResult("Unable to process this request");
    }
  }
}

extension TelosSigningManager on SigningRequestManager {
  static SigningRequestManager from(String? uri) {
    return SigningRequestManager.from(uri,
        options: defaultSigningRequestEncodingOptions(nodeUrl: remoteConfigurations.defaultEndPointUrl));
  }

  Future<List<Action>> fetchActions({String? account, String permission = "active"}) async {
    final abis = await fetchAbis();

    final auth = Authorization();
    auth.actor = account;
    auth.permission = permission;

    final actions = resolveActions(abis, auth);

    return actions;
  }
}
