import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/transaction_model.dart';
import 'package:async/async.dart';

class TransactionsListRepository extends NetworkRepository {
  Future<Result> getTransactions(String userAccount) async {
    final transactionsUrl =
        Uri.parse('$baseURL/v2/history/get_actions?account=$userAccount&act.name=transfer&skip=0&limit=100&sort=desc');

    return http
        .get(transactionsUrl)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              List<dynamic> transfers = body['actions'].toList();

              return List<TransactionModel>.of(transfers.map((transfer) => TransactionModel.fromJson(transfer)));
            }))
        .catchError((dynamic error) => mapHttpError(error));
  }
}
