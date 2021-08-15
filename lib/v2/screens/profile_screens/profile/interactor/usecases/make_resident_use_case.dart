import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';

class MakeResidentUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();
  var account = settingsStorage.accountName;

  Future<Result> run() {
    return _profileRepository.makeResident(account);
  }
}
