import 'package:async/async.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';
import 'package:seeds/v2/datasource/settings_storage.dart';

export 'package:async/src/result/result.dart';

class GetProfileUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();
  final accountName = settingsStorage.accountName;

  Future<Result> run() {
    return _profileRepository.getProfile(accountName);
  }
}
