import 'package:seeds/crypto/eosdart_ecc/eosdart_ecc.dart';

class CheckPrivateKeyUseCase {
  String? isKeyValid(String privateKey) {
    try {
      final EOSPrivateKey eosPrivateKey = EOSPrivateKey.fromString(privateKey);
      final EOSPublicKey eosPublicKey = eosPrivateKey.toEOSPublicKey();
      return eosPublicKey.toString();
    } catch (e, s) {
      print("Error x EOSPrivateKey.fromString: $privateKey: $e");
      print(s);
      return null;
    }
  }
}
