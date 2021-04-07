import 'dart:convert';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/balance_model.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

class BalanceRepository extends NetworkRepository {
  String balanceEndpoint = "v1/chain/get_currency_balance";

  Future<Result<dynamic>> getBalance(String userAccount) {
    print('[http] get seeds getBalance $userAccount');

    // ignore: omit_local_variable_types
    final String request = '{"code":"token.seeds","account":"$userAccount","symbol":"SEEDS"}';
    final balanceURL = '$baseURL/$balanceEndpoint';

    return http
        .post(balanceURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return BalanceModel.fromJson(body);
            }))
        .catchError((dynamic error) => mapHttpError(error));
  }

  Future<Result> getHypha(String userAccount) async {
    print('[http] get hypha balance $userAccount');

    try {
      var response = await http.post(
        "$baseURL/$balanceEndpoint",
        headers: headers,
        body: jsonEncode({
          "code": "token.hypha",
          "account": userAccount,
          "symbol": "HYPHA",
        }),
      );

      return mapHttpResponse(response, (body) => BalanceModel.fromJson(body));
    } catch (err) {
      return mapHttpError(err);
    }
  }
}
