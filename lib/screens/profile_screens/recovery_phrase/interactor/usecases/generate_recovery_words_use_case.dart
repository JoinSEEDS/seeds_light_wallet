// // ignore: import_of_legacy_library_into_null_safe
// import 'package:eosdart_ecc/eosdart_ecc.dart';
// import 'package:seeds/datasource/local/settings_storage.dart';
// import 'package:seeds/screens/profile_screens/recovery_phrase/interactor/usecases/generate_key_from_recovery_words_use_case.dart';
// import 'package:seeds/screens/profile_screens/recovery_phrase/interactor/viewmodels/recovery_phrase_bloc.dart';
// import 'package:seeds/utils/mnemonic_code/hex.dart';
// import 'package:seeds/utils/mnemonic_code/mnemonic_code.dart';
//
// const STRENTH_FOR_TWELVE_WORDS = 16;
//
// /// Uses the private key to generate 16 words recovery phrase
// class GenerateRecoveryPhraseUseCase {
//
//
//   List<String> run() {
//
//     var bytes = randomBytes(STRENTH_FOR_TWELVE_WORDS);
//     var entropy = entropyToMnemonic(HEX.encode(bytes));
//     print(entropy);
//
//     var lis = entropy.split('-');
//     print("LIS " + lis.join('-'));
//
//
//
//     var privateKey = EOSPrivateKey.fromSeed(entropy);
//     print(privateKey);
//
//
//
//
//
//     // var initialWords = "gun-heavy-repair-clever-cart-bomb-horn-chicken-large-trash-face-yard-replace-joke-bleak-forest-skill-rural-comic-wait-unable-amused-topple-twist";
//     // print("initialWords:    " + initialWords.toString());
//     // var initialPrivateKeyFromWords = GenerateKeyFromRecoveryPhraseUseCase().run(initialWords.split("-"));
//     // print("initialPrivateKeyFromWords:    " + initialPrivateKeyFromWords.toString());
//     //
//     //
//     //
//     // final String entropyBack = HEX.encode(initialPrivateKeyFromWords.d);
//     // final String backToWordsFromPrivateKey = entropyToMnemonic(entropyBack);
//     // print("backToWordsFromPrivateKey    " + backToWordsFromPrivateKey.toString());
//     //
//     // var recreatePrivateKeysFromWords = GenerateKeyFromRecoveryPhraseUseCase().run(backToWordsFromPrivateKey.split("-"));
//     // print("recreatePrivateKeysFromWords:    " + recreatePrivateKeysFromWords.toString());
//
//
//
//
//     //
//     // print("WTF");
//     //
//     //
//     // // var privateKey = EOSPrivateKey.fromBuffer(randomBytes(128 ~/ 8));
//     //
//     // final String entropy = HEX.encode(randomBytes(128 ~/ 8));
//     //
//     //
//     // // Construct the EOS private key from string
//     // // final EOSPrivateKey privateKey = EOSPrivateKey.fromString(settingsStorage.privateKey);
//     // // print("privateKey    " + privateKey.toString());
//     // // final String entropy = HEX.encode(privateKey.d);
//     // print("entropy    " + entropy.toString());
//     // final String mnemonic = "observe-pattern-powder-stairs-then-rebuild-prison-wide-moon-rain-best-alien";//entropyToMnemonic(entropy);
//     // print("mnemonic    " + mnemonic.toString());
//     // var privateKey = EOSPrivateKey.fromSeed(mnemonic);
//     // print("privateKey    " + privateKey.toString());
//     //
//     //
//     // // final String entropyBack = HEX.encode(privateKey.d);
//     // // print("entropyBack    " + entropyBack.toString());
//     //
//     // // final String mnemonicBack = entropyToMnemonic(entropyBack);
//     // // print("mnemonicBack    " + mnemonicBack.toString());
//     //
//     // var nmAgain = "gun-heavy-repair-clever-cart-bomb-horn-chicken-large-trash-face-yard-replace-joke-bleak-forest-skill-rural-comic-wait-unable-amused-topple-twist";
//     // print("nmAgain    " + nmAgain.toString());
//     //
//     // var privateKeyAgain = GenerateKeyFromRecoveryPhraseUseCase().run(nmAgain.split("-"));
//     // print("privateKeyAgain    " + privateKeyAgain.toString());
//
//     // var listM = mnemonic.split('-');
//     // print("listM "+ listM.toString());
//     //
//     // var privateKeyBack = GenerateKeyFromRecoveryPhraseUseCase().run(listM);
//     // print("privateKeyBack "+ privateKeyBack.toString());
//
//
//     // print(mnemonic.split('-'));
//     return "mnem-onic".split('-');
//   }
// }
