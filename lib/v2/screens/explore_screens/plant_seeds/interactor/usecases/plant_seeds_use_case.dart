import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';

class PlantSeedsUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<Result> run({required double? amount}) {
    return _profileRepository.plantSeeds(amount: amount, accountName: settingsStorage.accountName);
  }
}
