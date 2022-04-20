import 'package:async/async.dart';
import 'package:seeds/datasource/local/models/scan_qr_code_result_data.dart';

import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/local/util/seeds_esr.dart';

/// Use case to handle an incoming ESR - EOSIO Signing Request
class GetSigningRequestUseCase {
  Future<Result<ScanQrCodeResultData>> run(String uri) async {
    try {
      final SeedsESR esr = SeedsESR(uri: uri);
      return esr
          .resolve(account: settingsStorage.accountName)
          .then((value) => esr.processResolvedRequest())
          .catchError((onError) {
        return ErrorResult("Error processing EOSIO Signing Request (ESR)");
      });
    } catch (error) {
      return ErrorResult('ESR link is invalid: $uri');
    }
  }
}
