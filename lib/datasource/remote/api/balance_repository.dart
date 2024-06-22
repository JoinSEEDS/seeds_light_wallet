import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';

class BalanceRepository extends HttpRepository {
  Future<Result<BalanceModel>> getTokenBalance(String userAccount,
      {required String tokenContract, required String symbol}) {
    print('[http] get getTokenBalance $userAccount for $symbol');

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
        .then((http.Response response) => mapHttpResponse<BalanceModel>(response, (dynamic body) {
              final balance = BalanceModel.fromJson(body);
              updateTokenPrecision(balance, tokenContract: tokenContract, symbol: symbol);
              return balance;
            }))
        .catchError((dynamic error) => mapHttpError(error));
  }

  void updateTokenPrecision(BalanceModel balance, {required String tokenContract, required String symbol}) {
    TokenModel.setTokenPrecision(balance.precision, contract: tokenContract, symbol: symbol);
  }
}
