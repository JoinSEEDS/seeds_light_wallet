import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

class BalanceRepository extends NetworkRepository {
  Future<Result<dynamic>> getBalance(String userAccount) {
    print('[http] get seeds getBalance $userAccount');

    // ignore: omit_local_variable_types
    final String request = '{"code":"token.seeds","account":"$userAccount","symbol": "$currencySeedsCode" }';
    final balanceURL = Uri.parse('$baseURL/v1/chain/get_currency_balance');

    return http
        .post(balanceURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return BalanceModel.fromJson(body);
            }))
        .catchError((dynamic error) => mapHttpError(error));
  }
}
