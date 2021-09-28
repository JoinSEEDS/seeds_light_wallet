import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';

class UnplantSeedsUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<Result> run({required double amount}) {
    return _profileRepository.unplantSeeds(amount: amount, accountName: settingsStorage.accountName);
  }
}
