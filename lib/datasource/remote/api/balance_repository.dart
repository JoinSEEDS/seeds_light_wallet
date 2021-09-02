import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/network_repository.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';

class BalanceRepository extends NetworkRepository {
  Future<Result<dynamic>> getTokenBalance(String userAccount, {required String tokenContract, required String symbol}) {
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
        .post(balanceURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return BalanceModel.fromJson(body);
            }))
        .catchError((dynamic error) => mapHttpError(error));
  }
}
