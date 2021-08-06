import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/seeds_history_repository.dart';

class GetTransUseCase {
  final SeedsHistoryRepository _seedsHistoryRepository = SeedsHistoryRepository();

  Future<Result> run() {
    var account = settingsStorage.accountName;
    return _seedsHistoryRepository.getNumberOfTransactions(account);
  }
}
