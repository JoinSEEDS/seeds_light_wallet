import 'package:async/async.dart';
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/model/transaction_model.dart';

class TransactionsListRepository extends HttpRepository {
  Future<Result<List<TransactionModel>>> getTransactions(String userAccount) async {
    final transactionsUrl = Uri.parse(
        '$v2historyURL/v2/history/get_actions?account=$userAccount&act.name=transfer&skip=0&limit=100&sort=desc');

    return http
        .get(transactionsUrl)
        .then((response) => mapHttpResponse<List<TransactionModel>>(response, (body) {
              final List<dynamic> transfers = body['actions'].toList();

              return List<TransactionModel>.of(transfers.map((transfer) => TransactionModel.fromJson(transfer)));
            }))
        .catchError((error) => mapHttpError(error));
  }
}
