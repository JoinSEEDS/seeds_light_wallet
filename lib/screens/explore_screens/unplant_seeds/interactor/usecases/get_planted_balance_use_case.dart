import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/planted_repository.dart';

class GetPlantedBalanceUseCase {
  final PlantedRepository _plantedRepository = PlantedRepository();

  Future<Result> run() {
    final account = settingsStorage.accountName;

    return _plantedRepository.getPlanted(account);
  }
}
