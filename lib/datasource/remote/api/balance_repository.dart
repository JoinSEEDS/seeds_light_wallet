import 'package:async/async.dart';
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';

class BalanceRepository extends HttpRepository {
  Future<Result<BalanceModel>> getTokenBalance(String userAccount,
      {required String tokenContract, required String symbol}) {
    print('[http] get seeds getTokenBalance $userAccount for $symbol');

    final String request = '''
    {
      "code":"$tokenContract",
      "account":"$userAccount",
      "symbol":"$symbol" 
    }
    ''';

    final balanceURL = Uri.parse('$baseURL/v1/chain/get_currency_balance');

    return http
        .post(balanceURL, body: request)
        .then((response) => mapHttpResponse<BalanceModel>(response, (body) => BalanceModel.fromJson(body)))
        .catchError((dynamic error) => mapHttpError(error));
  }
}
