import 'package:eosdart_ecc/eosdart_ecc.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

class CheckPrivateKeyUseCase {
  String? isKeyValid(String privateKey) {
    try {
      EOSPrivateKey eosPrivateKey = EOSPrivateKey.fromString(privateKey);
      EOSPublicKey eosPublicKey = eosPrivateKey.toEOSPublicKey();
      return eosPublicKey.toString();
    } catch (e) {
      print("Error EOSPrivateKey.fromString");
      return null;
    }
  }
}
