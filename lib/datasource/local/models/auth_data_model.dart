import 'package:seeds/crypto/eosdart_ecc/eosdart_ecc.dart';

class AuthDataModel {
  final EOSPrivateKey eOSPrivateKey;
  final List<String> words;

  AuthDataModel(this.eOSPrivateKey, this.words);

  AuthDataModel.fromKeyAndWords(String key, this.words) : eOSPrivateKey = EOSPrivateKey.fromString(key);

  AuthDataModel.fromKeyAndNoWords(String key)
      : eOSPrivateKey = EOSPrivateKey.fromString(key),
        words = [];
}
