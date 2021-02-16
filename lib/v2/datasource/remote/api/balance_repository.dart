import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/balance_model.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

class BalanceRepository extends NetworkRepository {
  Future<Result> getBalance(String userAccount) {
    print("[http] get seeds getBalance $userAccount");

    String request = '{"code":"token.seeds","account":"$userAccount","symbol":"SEEDS"}';
    final String balanceURL = "$baseURL/v1/chain/get_currency_balance";

    return http
        .post(balanceURL, headers: headers, body: request)
        .then((http.Response response) => mapSuccess(response, (dynamic body) {
              print("getBalance Response success");
              print("BalanceModel" + BalanceModel.fromJson(body).formattedQuantity);
              return BalanceModel.fromJson(body);
            }))
        .catchError((error) => mapError(error));
  }
}
