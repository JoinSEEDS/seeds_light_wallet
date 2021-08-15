import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';

class GetUserAccountUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<List<Result>> run() {
    // TODO(raul): why this return a list ??
    final futures = [
      _profileRepository.getProfile(settingsStorage.accountName),
    ];
    return Future.wait(futures);
  }
}
