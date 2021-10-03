import 'package:seeds/datasource/local/auth_service.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';

/// Generates a private key and words
class GenerateRandomKeyAndWordsUseCase {
  AuthDataModel run() {
    return AuthService().createRandomPrivateKeyAndWords();
  }
}
