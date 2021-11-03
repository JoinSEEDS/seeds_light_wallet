import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';

class ClaimSeedsUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<Result> run({required List<int> requestIds}) {
    final account = settingsStorage.accountName;
    return _profileRepository.claimRefund(accountName: account, requestIds: requestIds);
  }
}
