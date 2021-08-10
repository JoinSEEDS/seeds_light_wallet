import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/planted_repository.dart';
import 'package:seeds/v2/datasource/remote/api/seeds_history_repository.dart';

class GetCitizenshipDataUseCase {
  final PlantedRepository _plantedRepository = PlantedRepository();
  final SeedsHistoryRepository _seedsHistoryRepository = SeedsHistoryRepository();

  Future<List<Result>> run() {
    final account = settingsStorage.accountName;
    final futures = [
      _plantedRepository.getPlanted(account),
      _seedsHistoryRepository.getNumberOfTransactions(account),
    ];
    return Future.wait(futures);
  }
}
