import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';

class GetScoresUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<Result> run() {
    return _profileRepository.getScore(settingsStorage.accountName);
  }
}
