import 'dart:convert';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/constants/config.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_remote_config.dart';

abstract class NetworkRepository {
  String baseURL = Config.defaultEndpoint;
  String hyphaURL = remoteConfigurations.hyphaEndPoint;
  String fxApiKey = Config.fxApiKey;
  Map<String, String> headers = {'Content-type': 'application/json'};

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
        return ErrorResult(NetworkError(response.statusCode));
    }
  }

  Result mapHttpError(error) {
    print('mapHttpError: ' + error.toString());
    return ErrorResult(error);
  }
}

class NetworkError extends Error {
  int statusCode;

  NetworkError(this.statusCode);
}
