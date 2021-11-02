import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/planted_repository.dart';

class GetPlantedBalanceUseCase {
  final PlantedRepository _plantedRepository = PlantedRepository();

  Future<List<Result>> run() {
    final account = settingsStorage.accountName;

    final futures = [_plantedRepository.getPlanted(account), _plantedRepository.getRefunds(account)];

    return Future.wait(futures);
  }
}
