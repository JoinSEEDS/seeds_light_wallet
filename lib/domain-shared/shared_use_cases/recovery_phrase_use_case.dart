// ignore: import_of_legacy_library_into_null_safe
import 'dart:typed_data';

import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:seeds/utils/mnemonic_code/hex.dart';
import 'package:seeds/utils/mnemonic_code/mnemonic_code.dart';

class RecoveryPhraseUseCase {
  void run() {

    // Construct the EOS private key from string
    EOSPrivateKey privateKeyFromString =
        EOSPrivateKey.fromString('5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3');
    print("privateKeyFromString " + privateKeyFromString.toString());

    String entroPy = HEX.encode(privateKeyFromString.d);
    print("entroPy " + entroPy.toString());

    String mNeumonicValue = entropyToMnemonic(entroPy);
    print("mNeumonicValue " + mNeumonicValue.toString());

    String entropyValue = mnemonicToEntropy(mNeumonicValue);
    print("entropyValue " + entropyValue.toString());
    
    var decoded = HEX.decode(entropyValue);
    EOSPrivateKey backToPrivate = EOSPrivateKey.fromBuffer(Uint8List.fromList(decoded));
    print("backToPrivate " + backToPrivate.toString());


  }
}
