import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/transactions_repository.dart';

class LoadTransactionsUseCase {
  Future<Result> run() {
    final account = settingsStorage.accountName;

    return TransactionsListRepository().getTransactions(account);
  }
}
