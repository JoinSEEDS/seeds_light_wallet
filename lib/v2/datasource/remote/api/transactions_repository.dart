import 'package:async/src/result/result.dart';
import 'package:http/http.dart';
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/transaction_model.dart';

class TransactionsRepository extends NetworkRepository {
  Future<Result> getTransactions(String userAccount) async {
    final transactionsUrl = Uri.parse(
        '$baseURL/v2/history/get_actions?account=$userAccount&act.name=transfer&skip=0&limit=100&sort=desc');

    try {
      final response = await get(transactionsUrl);

      return mapHttpResponse(response, (body) {
        List<dynamic> transfers = body['actions'].toList();

        return transfers.map((transfer) => TransactionModel.fromJson(transfer));
      });
    } catch (err) {
      return mapHttpError(err);
    }
  }
}
