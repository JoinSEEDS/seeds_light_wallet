// ignore: import_of_legacy_library_into_null_safe
import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/utils/mnemonic_code/hex.dart';
import 'package:seeds/utils/mnemonic_code/mnemonic_code.dart';

/// Uses the private key to generate 16 words recovery phrase
class GenerateRecoveryPhraseUseCase {
  List<String> run() {
    // Construct the EOS private key from string
    final EOSPrivateKey privateKey = EOSPrivateKey.fromString(settingsStorage.privateKey);
    final String entropy = HEX.encode(privateKey.d);
    final String mnemonic = entropyToMnemonic(entropy);

    return mnemonic.split('-');
  }
}
