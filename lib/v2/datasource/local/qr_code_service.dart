import 'package:async/async.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:dart_esr/dart_esr.dart';
import 'package:seeds/v2/datasource/local/models/scan_qr_code_result_data.dart';
import 'package:seeds/v2/datasource/local/util/seeds_esr.dart';

class QrCodeService {
  Future<Result<dynamic>> processQrCode(String scanResult, String accountName) {
    final splitUri = scanResult.split(':');
    final scheme = splitUri[0];
    if (scanResult is! String || scheme != 'esr' && scheme != 'web+esr') {
      print(" processQrCode : Invalid QR code");
      return Future.value(ErrorResult('Invalid QR Code'));
    }

    final SeedsESR esr = SeedsESR(uri: scanResult);
    return esr.resolve(account: accountName).then((value) => processResolvedRequest(esr)).catchError((onError) {
      print(" processQrCode : Error processing QR code");
      return ErrorResult("Error processing QR code");
    });
  }
}

Result processResolvedRequest(SeedsESR esr) {
  final Action action = esr.actions.first;
  if (_canProcess(action)) {
    final Map<String, dynamic> data = Map<String, dynamic>.from(action.data! as Map<dynamic, dynamic>);
    print(
        " processResolvedRequest: Success QR contract: ${action.account} action: ${action.name} data: ${action.data!}");
    return ValueResult(ScanESRResultData(data: data, accountName: action.account, actionName: action.name));
  } else {
    print("processResolvedRequest: canProcess is false: ");
    return ErrorResult("Invalid QR code");
  }
}

bool _canProcess(Action action) {
  return action.account!.isNotEmpty && action.name!.isNotEmpty;
}
