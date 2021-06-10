import 'dart:convert';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/constants/config.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_remote_config.dart';

abstract class NetworkRepository {
  String baseURL = remoteConfigurations.defaultEndPointUrl;
  String hyphaURL = remoteConfigurations.hyphaEndPoint;
  String fxApiKey = Config.fxApiKey;
  Map<String, String> headers = {'Content-type': 'application/json'};
  String account_seeds = 'accts.seeds';
  String account_guards = 'guard.seeds';
  String account_harvest = 'harvst.seeds';
  String account_join = 'join.seeds';
  String account_funds = 'funds.seeds';
  String account_alliance = 'alliance';

  String table_users = 'users';
  String table_guards = 'guards';
  String table_voice = 'voice';
  String table_invites = 'invites';
  String table_balances = 'balances';
  String table_props = 'props';

  Result mapHttpResponse(http.Response response, Function modelMapper) {
    print('mapHttpResponse - statusCode: ' + response.statusCode.toString());
    switch (response.statusCode) {
      case 200:
        {
          print('Model Class: ' + modelMapper.toString());
          var body = json.decode(response.body);
          return ValueResult(modelMapper(body));
        }
      default:
        print("network error: ${response.reasonPhrase}");
        return ErrorResult(NetworkError(response.statusCode));
    }
  }

  Result mapHttpError(error) {
    print('mapHttpError: ' + error.toString());
    return ErrorResult(error);
  }

  String createRequest({
    required String code,
    required String scope,
    required String table,
    String? lowerBound,
    String? upperBound,
    String tableKey = "",
    String keyType = "i64",
    int indexPosition = 1,
    int limit = 1,
    bool reverse = false,
    bool showPayer = false,
  }) {
    String request =
        '{"json": true, "code": "$code", "scope": "$scope", "table": "$table", "table_key":"$tableKey", "lower_bound": "$lowerBound", "upper_bound": "$upperBound", "index_position": "$indexPosition", "key_type": "$keyType", "limit": $limit, "reverse": $reverse, "show_payer":"$showPayer"}';

    return request;
  }
}

class NetworkError extends Error {
  int statusCode;

  NetworkError(this.statusCode);
}
