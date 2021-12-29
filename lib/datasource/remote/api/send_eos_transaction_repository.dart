import 'package:async/async.dart';
import 'package:seeds/crypto/eosdart/eosdart.dart';
import 'package:seeds/datasource/local/models/eos_transaction.dart';
import 'package:seeds/datasource/remote/api/eos_repo/eos_repository.dart';

class SendTransactionRepository extends EosRepository {
  Future<Result> sendTransaction({
    required EOSTransaction eosTransaction,
    required String accountName,
  }) async {
    print("send eos tx");

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

    print("[eos] send transaction ${actions[0].toString()}");

    final transaction = buildFreeTransaction(actions, accountName);

    print("[eos] PUSH ${transaction.toJson()}");

    // final client = buildEosClient();

    // print("[eos] got client $client");

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse(response, (dynamic map) {
              print("push success! ${response.toString()}");
              return response["transaction_id"];
            }))
        .catchError((error) {
      print("EOS ERROR $error");
      mapEosError(error);
    });
  }
}
