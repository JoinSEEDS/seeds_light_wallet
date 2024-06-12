import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_smart_contract_accounts.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_tables.dart';
import 'package:seeds/datasource/remote/api/planted_repository.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';
import 'package:seeds/datasource/remote/api/seeds_history_repository.dart';

class GetCitizenshipDataUseCase {
  final PlantedRepository _plantedRepository = PlantedRepository();
  final SeedsHistoryRepository _seedsHistoryRepository = SeedsHistoryRepository();
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<List<Result>> run() {
    final account = settingsStorage.accountName;
    final futures = [
      _plantedRepository.getPlanted(account),
      _seedsHistoryRepository.getNumberOfTransactions(account),
      _profileRepository.getScore(
        account: account,
        contractName: SeedsCode.accountAccounts,
        tableName: SeedsTable.tableRep,
      ),
    ];
    return Future.wait(futures);
  }
}
