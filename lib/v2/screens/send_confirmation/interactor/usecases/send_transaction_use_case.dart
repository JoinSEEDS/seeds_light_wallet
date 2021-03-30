import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';
import 'package:seeds/v2/datasource/remote/api/send_eos_transaction_repository.dart';

export 'package:async/src/result/result.dart';

class SendTransactionUseCase {
  final SendTransactionRepository _sendTransactionRepository = SendTransactionRepository();
  final accountName = settingsStorage.accountName;

  Future<Result> run(String name, String account, Map<String, dynamic> data) {
    return _sendTransactionRepository.sendTransaction(name, account, data, accountName);
  }
}
