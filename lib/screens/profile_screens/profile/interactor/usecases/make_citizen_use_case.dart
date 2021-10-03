import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';

class MakeCitizenUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();
  final String account = settingsStorage.accountName;

  Future<Result> run() {
    return _profileRepository.makeCitizen(account);
  }
}
