import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/domain-shared/shared_use_cases/is_current_key_12_words_use_case.dart';

class ShouldShowRecoveryPhraseFeatureUseCase {
  bool shouldShowRecoveryPhrase() =>
      remoteConfigurations.featureFlagExportRecoveryPhraseEnabled &&
      IsCurrentKey12WordsUseCase().getWordsList().isNotEmpty;
}
