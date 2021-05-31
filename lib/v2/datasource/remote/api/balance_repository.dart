import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/datasource/local/models/token_model.dart';
export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

class BalanceRepository extends NetworkRepository {

  Future<Result<dynamic>> getBalance(String userAccount) {
    return getTokenBalance(userAccount, SeedsToken);
  }

  Future<Result<dynamic>> getTokenBalance(String userAccount, TokenModel token) {
    print('[http] get seeds getTokenBalance $userAccount for ${token.symbol}');
    
    final String request = '''{
      "code":"${token.contract}",
      "account":"$userAccount",
      "symbol":"${token.symbol}" 
    }''';

    final balanceURL = Uri.parse('$baseURL/v1/chain/get_currency_balance');

    return http
        .post(balanceURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return BalanceModel.fromJson(body);
            }))
        .catchError((dynamic error) => mapHttpError(error));
  }

}
