import 'dart:convert';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/models/models.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

class ProfileRepository extends NetworkRepository {
  Future<Result> getProfile(String accountName) {
    String request =
        '{"json":true,"code":"accts.seeds","scope":"accts.seeds","table":"users","table_key":"","lower_bound":" $accountName","upper_bound":" $accountName","index_position":1,"key_type":"i64","limit":1,"reverse":false,"show_payer":false}';

    return http
        .post(profileURL, headers: headers, body: request)
        .then((http.Response response) => mapSuccess(response, (dynamic body) {
              return ProfileModel.fromJson(body["rows"][0]);
            }))
        .catchError((error) => mapError(error));
  }
}

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
