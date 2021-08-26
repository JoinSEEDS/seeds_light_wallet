// ignore: import_of_legacy_library_into_null_safe
import 'package:dart_esr/dart_esr.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/v2/datasource/local/models/scan_qr_code_result_data.dart';
import 'package:async/async.dart';

class SeedsESR {
  late SigningRequestManager manager;

  late List<Action> actions;

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
    final Action action = actions.first;
    if (_canProcess(action)) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(action.data! as Map<dynamic, dynamic>);
      print(
          " processResolvedRequest: Success QR contract: ${action.account} action: ${action.name} data: ${action.data!}");
      return ValueResult(ScanQrCodeResultData(data: data, accountName: action.account, actionName: action.name));
    } else {
      print("processResolvedRequest: canProcess is false: ");
      return ErrorResult("Unable to process this request");
    }
  }

  // TODO(n13): Remove - see above.
  bool _canProcess(Action action) {
    return action.account!.isNotEmpty && action.name!.isNotEmpty;
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
