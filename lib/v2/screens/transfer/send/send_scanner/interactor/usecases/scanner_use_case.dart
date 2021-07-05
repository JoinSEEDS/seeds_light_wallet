import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/qr_code_service.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';

class ProcessScanResultUseCase {
  QrCodeService qrCodeService = QrCodeService();

  Future<Result> run(String scanResult) async {
    return qrCodeService.processQrCode(scanResult, settingsStorage.accountName);
  }
}
