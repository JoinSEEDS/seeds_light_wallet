import 'dart:convert';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

abstract class NetworkRepository {
  final String profileURL = 'https://mainnet.telosusa.io/v1/chain/get_table_rows';
  Map<String, String> headers = {"Content-type": "application/json"};

  Result mapSuccess(http.Response response, Function modelMapper) {
    print("mapSuccess - statusCode: " + response.statusCode.toString());
    switch (response.statusCode) {
      case 200:
        {
          var body = json.decode(response.body);
          return ValueResult(modelMapper(body));
        }
      default:
        return ErrorResult(NetworkError(response.statusCode));
    }
  }

  Result mapError(error) {
    print("mapError: " + error.toString());
    return ErrorResult(error);
  }
}

class NetworkError extends Error {
  int statusCode;

  NetworkError(this.statusCode);
}
