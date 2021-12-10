// ignore: import_of_legacy_library_into_null_safe
import 'package:eosdart_ecc/eosdart_ecc.dart';
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

  EOSPrivateKey createPrivateKeyFrom12WordsBip39(List<String> words) {
    assert(words.length == 12);

    /// TODO(m13): make this create the seeds the same way passport does it
    ///
    /// Sample EOS key
    /// https://www.bcskill.com/index.php/archives/966.html
    ///
    /// https://github.com/rudijs/eos-bip39-mnemonic-generator
    ///
    /// https://pub.dev/packages/pinenacl
    ///
    /// HD key - this looks good
    /// https://pub.dev/packages/ed25519_hd_key
    ///
    ///   const hdwallet = hdkey.fromMasterSeed(bip39.mnemonicToSeed(seed));
    // const wallet_hdpath = "m/44'/60'/0'/0/";
    // const accounts = [];
    // const wallet = hdwallet.derivePath(wallet_hdpath).getWallet();

    /// 1 - user Bip39 to create a seed
    /// 2 - use hd wallet to derive a private key
    /// 3 - use the ETH private key to create an EOS private key
    ///
    return EOSPrivateKey.fromSeed(words.join(' '));
  }

  /// Creates 12 random words Mnemonic.
  List<String> _createRandom12Words() {
    final bytes = randomBytes(STRENGTH_FOR_TWELVE_WORDS);
    return entropyToMnemonic(HEX.encode(bytes)).split('-');
  }
}
