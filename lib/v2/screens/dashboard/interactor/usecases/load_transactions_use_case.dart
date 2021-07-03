import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/transactions_repository.dart';

import 'package:async/src/result/result.dart';

class LoadTransactionsUseCase {
  Future<Result> run() {
    final account = settingsStorage.accountName;

    return TransactionsRepository().getTransactions(account);
  }
}
