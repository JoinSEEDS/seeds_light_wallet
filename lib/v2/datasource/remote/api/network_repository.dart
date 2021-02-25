import 'dart:convert';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/constants/config.dart';

abstract class NetworkRepository {
  String baseURL = Config.defaultEndpoint;
  String hyphaURL = Config.hyphaEndpoint;
  Map<String, String> headers = {'Content-type': 'application/json'};

  Result mapSuccess(http.Response response, Function modelMapper) {
    print('mapSuccess - statusCode: ' + response.statusCode.toString());
    switch (response.statusCode) {
      case 200:
        {
          print('Model Class: ' + modelMapper.toString());
          var body = json.decode(response.body);
          return ValueResult(modelMapper(body));
        }
      default:
        return ErrorResult(NetworkError(response.statusCode));
    }
  }

  Result mapEosSuccess(dynamic response, Function modelMapper) {
    print('mapSuccess - transaction id: ${response['transaction_id']}');
    if (response['transaction_id'] != null) {
      print('Model Class: $modelMapper');
      var map = Map<String, dynamic>.from(response);
      return ValueResult(modelMapper(map));
    } else {
      return ErrorResult(EosError(response['processed']['error_code']));
    }
  }

  Result mapError(error) {
    print('mapError: ' + error.toString());
    return ErrorResult(error);
  }
}

class NetworkError extends Error {
  int statusCode;

  NetworkError(this.statusCode);
}

class EosError extends Error {
  int errorCode;

  EosError(this.errorCode);
}
