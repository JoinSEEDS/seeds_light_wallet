import 'package:seeds/datasource/local/auth_service.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';

/// Uses 12 words recovery phrase to generate the private key.
class GenerateKeyFromSeedsPassportWordsUseCase {
  AuthDataModel run(List<String> recoveryWords) {
    return AuthService().privateKeyFromSeedsGlobalPassportWords(recoveryWords);
  }
}
