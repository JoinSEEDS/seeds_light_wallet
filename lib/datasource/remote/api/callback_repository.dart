import 'dart:convert';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';

class CallbackRepository extends HttpRepository {
  Future<Result<bool>> callback(String _callbackUrl, String transactionId) {
    print("[http] issue callback $_callbackUrl");

    final callbackUrl = fillTemplate(_callbackUrl, transactionId);
    final uri = Uri.parse(callbackUrl);
    final params = jsonEncode(uri.queryParameters);
    final postURI = Uri(scheme: uri.scheme, host: uri.host, path: uri.path);

    return http
        .post(postURI, headers: headers, body: params)
        .then((http.Response response) => mapHttpResponse<bool>(response, (dynamic body) {
              return true;
            }))
        .catchError((error) => mapHttpError(error));
  }

  String fillTemplate(String callbackURL, String transactionId) {
    /// See spec
    /// https://github.com/eosio-eps/EEPs/blob/master/EEPS/eep-7.md#4-issuing-callbacks
    return callbackURL.replaceAll("{{tx}}", transactionId);
  }
}
