import 'dart:typed_data';

// ignore: import_of_legacy_library_into_null_safe
import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:seeds/utils/mnemonic_code/hex.dart';
import 'package:seeds/utils/mnemonic_code/mnemonic_code.dart';

/// Uses 16 words recovery phrase to generate the private key.
class GenerateKeyFromRecoveryPhraseUseCase {
  EOSPrivateKey run(List<String> recoveryPhrase) {
    final String entropyValue = mnemonicToEntropy(recoveryPhrase);
    final decoded = HEX.decode(entropyValue);
    final EOSPrivateKey privateKey = EOSPrivateKey.fromBuffer(Uint8List.fromList(decoded));

    return privateKey;
  }
}
