import 'package:async/async.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/local/util/seeds_esr.dart';

class GetSigningRequestUseCase {
  Future<Result> run(String uri) async {
    try {
      final SeedsESR esr = SeedsESR(uri: uri);
      return esr
          .resolve(account: settingsStorage.accountName)
          .then((value) => esr.processResolvedRequest())
          .catchError((onError) {
        print(" processQrCode : Error processing QR code");
        return ErrorResult("Error processing QR code");
      });
    } catch (error) {
      print("error handling esr or invalid esr: $uri");
      return ErrorResult('ESR link is invalid');
    }
  }
}
