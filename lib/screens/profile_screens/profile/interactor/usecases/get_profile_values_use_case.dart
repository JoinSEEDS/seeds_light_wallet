import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';

class GetProfileValuesUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<List<Result>> run() {
    final account = settingsStorage.accountName;
    final futures = [
      _profileRepository.getProfile(account),
      _profileRepository.getScore(account: account, tableName: "cspoints"),
      _profileRepository.getScore(account: account, contractName: "accts.seeds", tableName: "cbs"),
      _profileRepository.getScore(account: account, contractName: "accts.seeds", tableName: "rep"),
      _profileRepository.getScore(account: account, tableName: "planted"),
      _profileRepository.getScore(account: account, tableName: "txpoints"),
      _profileRepository.getOrganizationAccount(account),
      _profileRepository.canResident(account),
      _profileRepository.canCitizen(account),
    ];
    return Future.wait(futures);
  }
}
