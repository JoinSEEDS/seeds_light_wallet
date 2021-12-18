import 'package:async/async.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:seeds/datasource/local/util/seeds_esr.dart';

class QrCodeService {
  Future<Result<dynamic>> processQrCode(String scanResult, String accountName) {
    final splitUri = scanResult.split(':');
    final scheme = splitUri[0];
    if (scheme != 'esr' && scheme != 'web+esr') {
      print(" processQrCode : Invalid QR code");
      return Future.value(ErrorResult('Invalid QR Code'));
    }

    final SeedsESR esr = SeedsESR(uri: scanResult);
    return esr.resolve(account: accountName).then((value) => esr.processResolvedRequest()).catchError((onError) {
      print(" processQrCode : Error processing QR code");
      return ErrorResult("Error processing QR code");
    });
  }
}
