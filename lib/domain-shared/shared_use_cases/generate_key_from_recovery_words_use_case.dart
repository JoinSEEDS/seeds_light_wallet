import 'package:seeds/datasource/local/auth_service.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';

/// Uses 12 words recovery phrase to generate the private key.
class GenerateKeyFromRecoveryPhraseUseCase {
  AuthDataModel run(List<String> recoveryPhrase) {
    return AuthService().createPrivateKeyFromWords(recoveryPhrase);
  }
}
