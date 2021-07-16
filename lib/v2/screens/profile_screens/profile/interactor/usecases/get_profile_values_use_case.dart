import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';

class GetProfileValuesUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<List<Result>> run() {
    var account = settingsStorage.accountName;
    var futures = [
      _profileRepository.getProfile(account),
      _profileRepository.getScore(account: account, tableName: "cspoints"),
      _profileRepository.getScore(account: account, contractName: "accts.seeds", tableName: "cbs"),
      _profileRepository.getScore(account: account, contractName: "accts.seeds", tableName: "rep"),
      _profileRepository.getScore(account: account, tableName: "planted"),
      _profileRepository.getScore(account: account, tableName: "txpoints"),
    ];
    return Future.wait(futures);
  }
}
