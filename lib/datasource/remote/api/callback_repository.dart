import 'dart:convert';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';

class CallbackRepository extends HttpRepository {
  Future<Result<String>> callback(String _callbackUrl, String transactionId) {
    print("[http] issue callback");

    final callbackUrl = fillTemplate(_callbackUrl, transactionId);

    String urlString = "";
    String params = "";
    try {
      final initialURI = Uri.parse(callbackUrl);
      if (initialURI.hasQuery) {
        urlString = "$callbackUrl&tx_id=$transactionId";
      } else {
        urlString = "$callbackUrl?tx_id=$transactionId";
      }
    } catch (err) {
      print("invalid callback URL");
    }

    final uri = Uri.parse(urlString);
    params = jsonEncode(uri.queryParameters);

    return http
        .post(uri, headers: headers, body: params)
        .then((http.Response response) => mapHttpResponse<String>(response, (dynamic body) {
              print("body $body");
              return "";
            }))
        .catchError((error) => mapHttpError(error));
  }

  String fillTemplate(String callbackURL, String transactionId) {
    // https://myapp.com/wallet?tx={{tx}}&included_in={{bn}}
    return callbackURL.replaceAll("{{tx}}", transactionId);
  }
}
