import 'package:async/async.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';

export 'package:async/src/result/result.dart';

class UpdateProfileUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();
  final accountName = settingsStorage.accountName;

  Future<Result> run({@required String name}) {
    return _profileRepository.updateProfile(
      accountName: accountName,
      nickname: name,
      image: '',
      story: '',
      roles: '',
      skills: '',
      interests: '',
    );
  }
}
