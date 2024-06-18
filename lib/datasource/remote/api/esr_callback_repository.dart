import 'dart:convert';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';

/// Implements EOSIO Signing Request callback function
/// https://github.com/greymass/eosio-signing-request/blob/master/protocol-specification.md
///
/// The callback URL also includes simple templating with some response parameters. The templating format syntax is {{param_name}}, e.g.:

// https://myapp.com/wallet?tx={{tx}}&included_in={{bn}}
// mymobileapp://signed/{{sig}}
// Available Parameters:

// bn: Block number hint (only present if transaction was broadcast).
// ex: Expiration time used when resolving request.
// rbn: Reference block num used when resolving request.
// req: The originating signing request encoded as a uri string.
// rid: Reference block id used when resolving request.
// sa: Signer authority string, aka account name.
// sp: Signer permission string, e.g. "active".
// req: The originating signing request packed as a uri string.
// sig: The first signature.
// sigX: All signatures are 0-indexed as sig0, sig1, etc.
// cid: Chain id used when resolving the request.
// tx: Transaction id used when resolving request.

/// Note: We only support the tx parameter for now.
/// If there is a need we can add more parameters later but we would have
/// to return full transaction results rather than just tx ID from transactions
/// And some of these other parameters require even more changes.

/// At the moment can't justify the effort for a generic implementation.

class ESRCallbackRepository extends HttpRepository {
  Future<Result<bool>> callback(String callbackUrl, String transactionId) {
    print("[http] issue callback $callbackUrl");

    final callbackURL = fillTemplate(callbackUrl, transactionId);
    final uri = Uri.parse(callbackURL);
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
