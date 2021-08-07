import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/planted_repository.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';

class GetProfileValuesUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<List<Result>> run() {
    var account = settingsStorage.accountName;
    var futures = [
      _profileRepository.getProfile(account),
      _profileRepository.getScore(account: account, tableName: "cspoints", pointsName: "contribution_points"),
      _profileRepository.getScore(
          account: account, contractName: "accts.seeds", tableName: "cbs", pointsName: "community_building_score"),
      _profileRepository.getScore(account: account, contractName: "accts.seeds", tableName: "rep", pointsName: "rep"),
      PlantedRepository().getPlanted(account),
      _profileRepository.getScore(account: account, tableName: "txpoints", pointsName: "points"),
      _profileRepository.canResident(account),
      _profileRepository.canCitizen(account),
    ];
    return Future.wait(futures);
  }
}
