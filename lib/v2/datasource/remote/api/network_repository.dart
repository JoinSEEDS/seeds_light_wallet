import 'dart:convert';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/firebase/firebase_remote_config.dart';

abstract class NetworkRepository {
  String baseURL = remoteConfigurations.defaultEndPointUrl;
  String hyphaURL = remoteConfigurations.hyphaEndPoint;
  String fxApiKey = "thesecretapikey989";
  Map<String, String> headers = {'Content-type': 'application/json'};

  String table_balances = 'balances';
  String table_guards = 'guards';
  String table_harvest = 'harvest';
  String table_invites = 'invites';
  String table_moonphases = 'moonphases';
  String table_props = 'props';
  String table_refs = 'refs';
  String table_support = 'support';
  String table_users = 'users';
  String table_voice = 'voice';
  String table_votes = 'votes';
  String table_recover = 'recovers';

  Result mapHttpResponse(http.Response response, Function modelMapper) {
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
    String lowerBound = "",
    String upperBound = "",
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
