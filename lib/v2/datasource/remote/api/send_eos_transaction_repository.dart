import 'package:async/async.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:eosdart/eosdart.dart';
import 'package:seeds/v2/datasource/remote/api/eos_repository.dart';

class SendTransactionRepository extends EosRepository {
  Future<Result> sendTransaction(String? name, String account, Map<String, dynamic> data, String accountName) async {
    print('[eos] sendTransaction');

    var actions = [
      Action()
        ..account = account
        ..name = name
        ..data = data
    ];
    for (var action in actions) {
      action.authorization = [
        Authorization()
          ..actor = accountName
          ..permission = permissionActive
      ];
    }

    var transaction = buildFreeTransaction(actions, accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse(response, (dynamic map) {
              return response["transaction_id"];
            }))
        .catchError((error) => mapEosError(error));
  }
}
