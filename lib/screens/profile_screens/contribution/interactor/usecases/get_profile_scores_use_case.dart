import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_smart_contract_accounts.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_tables.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';

class GetProfileScoresUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<List<Result>> run() {
    final account = settingsStorage.accountName;
    final futures = [
      _profileRepository.getScore(account: account, tableName: SeedsTable.tableCspoints),
      _profileRepository.getScore(
          account: account, contractName: SeedsCode.accountAccounts, tableName: SeedsTable.tableCbs),
      _profileRepository.getScore(
          account: account, contractName: SeedsCode.accountAccounts, tableName: SeedsTable.tableRep),
      _profileRepository.getScore(account: account, tableName: SeedsTable.tablePlanted),
      _profileRepository.getScore(account: account, tableName: SeedsTable.tableTxpoints),
    ];
    return Future.wait(futures);
  }
}
