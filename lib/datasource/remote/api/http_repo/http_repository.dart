import 'dart:async';

import 'package:async/async.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/http_repo/seeds_scopes.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_tables.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/datasource/remote/util/response_extension.dart';

class _HttpClient extends http.BaseClient {
  final http.Client _httpClient = http.Client();
  Map<String, String> headers = {'Content-type': 'application/json'};

  // Intercept each call to log request info to Crashlytics.
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (kDebugMode) {
      print('${request.method} ${request.url} ${request.contentLength}');
    }
    FirebaseCrashlytics.instance.log('${request.method} ${request.url} ${(request as Request).body}');
    request.headers.addAll(headers);
    return _httpClient.send(request);
  }
}

abstract class HttpRepository {
  String baseURL = remoteConfigurations.defaultEndPointUrl;
  String v2historyURL = remoteConfigurations.defaultV2EndPointUrl;
  String hyphaURL = remoteConfigurations.hyphaEndPoint;
  String mapsApiKey = 'AIzaSyB3Ghs8i_Lw55vmSyh5mxLA9cGcWuc1A54';
  String fxApiKey = "thesecretapikey989";
  _HttpClient http = _HttpClient();

  FutureOr<Result<T>> mapHttpResponse<T>(Response response, Function modelMapper) {
    switch (response.statusCode) {
      case 200:
        {
          print('Model Class: $modelMapper');
          final body = response.parseJson();
          return ValueResult(modelMapper(body));
        }
      default:
        if (kDebugMode) {
          print('http error: ${response.reasonPhrase}');
        }
        FirebaseCrashlytics.instance.log('http error: ${response.statusCode}, ${response.reasonPhrase}');
        return ErrorResult(NetworkError(response.statusCode));
    }
  }

  ErrorResult mapHttpError(dynamic error) {
    if (kDebugMode) {
      print('mapHttpError: $error');
    }
    FirebaseCrashlytics.instance.log('mapHttpError: $error');
    return ErrorResult(error);
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
