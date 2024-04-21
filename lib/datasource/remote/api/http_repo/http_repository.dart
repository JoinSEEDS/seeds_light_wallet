import 'dart:async';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/http_repo/seeds_scopes.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_tables.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/datasource/remote/util/response_extension.dart';

abstract class HttpRepository {
  String baseURL = remoteConfigurations.defaultEndPointUrl;
  String v2historyURL = remoteConfigurations.defaultV2EndPointUrl;
  String hyphaURL = remoteConfigurations.hyphaEndPoint;
  String mapsApiKey = 'AIzaSyB3Ghs8i_Lw55vmSyh5mxLA9cGcWuc1A54';
  String fxApiKey = "thesecretapikey989";
  Map<String, String> headers = {'Content-type': 'application/json'};

  FutureOr<Result<T>> mapHttpResponse<T>(http.Response response, Function modelMapper, {String? about}) {
    switch (response.statusCode) {
      case 200:
        {
          print('Model Class: $modelMapper ${about ?? ""}');
          final body = response.parseJson();
          return ValueResult(modelMapper(body) as T);
        }
      default:
        print('network error: ${response.reasonPhrase} ${about ?? ""}');
        return ErrorResult(NetworkError(response.statusCode));
    }
  }

  ErrorResult mapHttpError(dynamic error, {String? about}) {
    print('mapHttpError: $error ${about ?? ""}');
    return ErrorResult(error as Object);
  }

  String createRequest({
    required SeedsCode code,
    required String scope,
    required SeedsTable table,
    String lowerBound = "",
    String upperBound = "",
    String tableKey = "",
    String keyType = "i64",
    int indexPosition = 1,
    int limit = 1,
    bool reverse = false,
    bool showPayer = false,
  }) {
    final tableName = table.value;
    final seedsCode = code.value;

    final String request =
        '{"json": true, "code": "$seedsCode", "scope": "$scope", "table": "$tableName", "table_key":"$tableKey", "lower_bound": "$lowerBound", "upper_bound": "$upperBound", "index_position": "$indexPosition", "key_type": "$keyType", "limit": $limit, "reverse": $reverse, "show_payer":"$showPayer"}';

    return request;
  }
}

class NetworkError extends Error {
  int statusCode;

  NetworkError(this.statusCode);
}
