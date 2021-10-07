import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';

class ShouldShowRecoveryPhraseFeatureUseCase {
  bool shouldShowRecoveryPhrase() =>
      remoteConfigurations.featureFlagExportRecoveryPhraseEnabled && settingsStorage.recoveryWords.isNotEmpty;
}
