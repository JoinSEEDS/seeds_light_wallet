// ignore: import_of_legacy_library_into_null_safe
import 'package:eosdart_ecc/eosdart_ecc.dart';

class CheckPrivateKeyUseCase {
  String? isKeyValid(String privateKey) {
    try {
      EOSPrivateKey eosPrivateKey = EOSPrivateKey.fromString(privateKey);
      EOSPublicKey eosPublicKey = eosPrivateKey.toEOSPublicKey();
      return eosPublicKey.toString();
    } catch (e, s) {
      print("Error EOSPrivateKey.fromString ${e}");
      print(s);
      return null;
    }
  }
}
