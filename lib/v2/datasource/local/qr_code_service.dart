import 'package:async/async.dart';
import 'package:dart_esr/dart_esr.dart';
import 'package:seeds/v2/datasource/local/models/scan_qr_code_result_data.dart';
import 'package:seeds/v2/datasource/local/qr_code_service.dart';
import 'package:seeds/v2/datasource/remote/api/balance_repository.dart';
import 'package:seeds/v2/datasource/remote/api/planted_repository.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';
import 'package:seeds/v2/datasource/remote/api/voice_repository.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

class QrCodeService {
  Future<Result<dynamic>> processQrCode(String scanResult, String accountName) {
    var splitUri = scanResult.split(':');
    var scheme = splitUri[0];
    if (scanResult is! String || scheme != 'esr' && scheme != 'web+esr') {
      print(" processQrCode : Invalid QR code");
      return Future.value(ErrorResult('Invalid QR Code'));
    }

    _SeedsESR esr = _SeedsESR(uri: scanResult);
    return esr.resolve(account: accountName).then((value) => processResolvedRequest(esr)).catchError((onError) {
      print(" processQrCode : Error processing QR code");
      return ErrorResult("Error processing QR code");
    });
  }
}

Result processResolvedRequest(_SeedsESR esr) {
  Action action = esr.actions.first;
  if (_canProcess(action)) {
    Map<String, dynamic> data = Map<String, dynamic>.from(action.data as Map<dynamic, dynamic>);
    print(" processResolvedRequest : Success QR code");
    return ValueResult(ScanQrCodeResultData(data: data, accountName: action.account, name: action.name));
  } else {
    print("processResolvedRequest: canProcess is false: ");
    return ErrorResult("Invalid QR code");
  }
}

bool _canProcess(Action action) {
  return action.account!.isNotEmpty && action.name!.isNotEmpty;
}

class _SeedsESR {
  late SigningRequestManager manager;

  late List<Action> actions;

  _SeedsESR({String? uri}) {
    manager = _TelosSigningManager.from(uri);
  }

  Future<void> resolve({String? account}) async {
    actions = await manager.fetchActions(account: account);
  }
}

extension _TelosSigningManager on SigningRequestManager {
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
