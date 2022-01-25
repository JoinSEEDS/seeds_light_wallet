import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/screens/authentication/import_key/interactor/usecases/generate_key_from_recovery_words_use_case.dart';
import 'package:seeds/screens/authentication/import_key/interactor/usecases/generate_key_from_seeds_passport_words_use_case.dart';

class GetWordsFromPrivateKey {
  /// If the private key has words, it returns the list of words
  /// otherwise an empty list.
  List<String> run() {
    final String privateKey = settingsStorage.privateKey!;

    final wordsString = settingsStorage.recoveryWords.firstWhere((item) {
      final words = item.toList();
      return GenerateKeyFromRecoveryWordsUseCase().run(words).eOSPrivateKey.toString() == privateKey ||
          GenerateKeyFromSeedsPassportWordsUseCase().run(words).eOSPrivateKey.toString() == privateKey;
    });

    if (wordsString.isNotEmpty) {
      return wordsString.toList();
    } else {
      return [];
    }
  }
}

extension WordListString on String {
  List<String> toList() {
    return split("-");
  }
}
