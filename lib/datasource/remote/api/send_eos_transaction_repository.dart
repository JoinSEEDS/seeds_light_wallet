import 'package:async/async.dart';
import 'package:seeds/crypto/eosdart/eosdart.dart';
import 'package:seeds/datasource/local/models/eos_transaction.dart';
import 'package:seeds/datasource/remote/api/eos_repo/eos_repository.dart';

class SendTransactionRepository extends EosRepository {
  Future<Result> sendTransaction({
    required EOSTransaction eosTransaction,
    required String accountName,
  }) async {
    final actions = eosTransaction.actions
        .map(
          (e) => Action()
            ..account = e.accountName
            ..name = e.actionName
            ..data = e.data,
        )
        .toList();

    for (final action in actions) {
      action.authorization = [
        Authorization()
          ..actor = accountName
          ..permission = permissionActive
      ];
    }
    final transaction = buildFreeTransaction(actions, accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse(response, (dynamic map) {
              return response["transaction_id"];
            }))
        .catchError((error) => mapEosError(error));
  }
}
