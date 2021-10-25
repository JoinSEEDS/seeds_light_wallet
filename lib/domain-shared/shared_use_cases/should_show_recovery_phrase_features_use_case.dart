import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/domain-shared/shared_use_cases/is_12_words_account_use_case.dart';

class ShouldShowRecoveryPhraseFeatureUseCase {
  bool shouldShowRecoveryPhrase() =>
      remoteConfigurations.featureFlagExportRecoveryPhraseEnabled &&
      IsCurrentKey12WordstUseCase().getWordsList().isNotEmpty;
}
