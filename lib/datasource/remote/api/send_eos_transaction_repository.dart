import 'package:async/async.dart';
import 'package:seeds/crypto/eosdart/eosdart.dart';
import 'package:seeds/datasource/local/models/eos_transaction.dart';
import 'package:seeds/datasource/remote/api/eos_repo/eos_repository.dart';

class SendTransactionRepository extends EosRepository {
  Future<Result> sendTransaction({
    required EOSTransaction eosTransaction,
    required String accountName,
  }) async {
    final actions = eosTransaction.actions.map((e) => e.toEosAction).toList();

    for (final action in actions) {
      if (action.authorization == null || action.authorization == []) {
        action.authorization = [
          Authorization()
            ..actor = accountName
            ..permission = permissionActive
        ];
      }
    }
    final transaction = buildFreeTransaction(actions, accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((response) => mapEosResponse(response, (body) => response["transaction_id"]))
        .catchError((error) => mapEosError(error));
  }
}
