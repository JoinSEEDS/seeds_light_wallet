import 'package:async/async.dart';
import 'package:eosdart/eosdart.dart';
import 'package:seeds/v2/datasource/remote/api/eos_repository.dart';

export 'package:async/src/result/result.dart';

class SendTransactionRepository extends EosRepository {
  Future<Result> sendTransaction(String name, String account, Map<String, dynamic> data, String accountName) async {
    print('[eos] sendTransaction');

    var actions = [
      Action()
        ..account = account
        ..name = name
        ..data = data
    ];

    actions.forEach((action) => {
          action.authorization = [
            Authorization()
              ..actor = accountName
              ..permission = 'active'
          ]
        });

    var transaction = buildFreeTransaction(actions, accountName);

    return buildEosClient()
        .pushTransaction(transaction, broadcast: true)
        .then((dynamic response) => mapEosResponse(response, (dynamic map) {
              return response["transaction_id"];
            }))
        .catchError((error) => mapEosError(error));
  }
}
