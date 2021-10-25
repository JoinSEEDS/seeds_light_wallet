import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/screens/authentication/import_key/interactor/usecases/generate_key_from_recovery_words_use_case.dart';

class IsCurrentKey12WordstUseCase {
  List<String> getWordsList() {
    final String privateKey = settingsStorage.privateKey!;

    ///-------IS PRIVATE KEY 12 WORDS TYPE
    // Convert all words into private keys
    final List<String> privateKeysListFromWords = settingsStorage.recoveryWords
        .map((i) => GenerateKeyFromRecoveryWordsUseCase().run(i.split('-')))
        .toList()
        .map((i) => '${i.eOSPrivateKey}')
        .toList();
    // Verify if there is a match with the selected private key
    final bool is12WordsAccount = privateKeysListFromWords.contains(privateKey);
    if (is12WordsAccount) {
      final int wordsIndex = privateKeysListFromWords.indexOf(privateKey);
      // Since the storage recover words and privateKeysListFromWords are map 1:1
      // the index will be the same to get the target words
      return settingsStorage.recoveryWords[wordsIndex].split('-');
    } else {
      return [];
    }
  }
}
