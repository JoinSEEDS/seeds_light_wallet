import 'package:seeds/crypto/eosdart_ecc/eosdart_ecc.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/utils/mnemonic_code/hex.dart';
import 'package:seeds/utils/mnemonic_code/mnemonic_code.dart';

const STRENGTH_FOR_TWELVE_WORDS = 16;

class AuthService {
  /// Creates a random private key/12 words pair. Used for user auth.
  AuthDataModel createRandomPrivateKeyAndWords() {
    final words = _createRandom12Words();

    return AuthDataModel(_createPrivateKeyFrom12Words(words), words);
  }

  /// Creates a private key/12 words pair. From words
  AuthDataModel createPrivateKeyFromWords(List<String> words) {
    return AuthDataModel(_createPrivateKeyFrom12Words(words), words);
  }

  /// Creates a private key from 12 words list
  EOSPrivateKey _createPrivateKeyFrom12Words(List<String> words) {
    assert(words.length == 12);
    return EOSPrivateKey.fromSeed(words.join('-'));
  }

  /// Creates 12 random words Mnemonic.
  List<String> _createRandom12Words() {
    final bytes = randomBytes(STRENGTH_FOR_TWELVE_WORDS);
    return entropyToMnemonic(HEX.encode(bytes)).split('-');
  }
}
