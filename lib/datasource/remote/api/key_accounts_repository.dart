import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';

class KeyAccountsRepository extends HttpRepository {

  Future<Result<dynamic>> getKeyAccounts(String publicKey) {
    print('[http] getKeyAccounts');

    final url = Uri.parse('$baseURL/v1/history/get_key_accounts');
    final body = '{ "public_key": "$publicKey" }';

    return http
        .post(url, headers: headers, body: body)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              print('result: $body');

              final result = List<String>.from(body['account_names'] as Iterable);

              result.sort();

              return result;
            }))
        .catchError((dynamic error) => mapHttpError(error));
  }
}
    
  // Future<Result<dynamic>> getAccountsByKey(String publicKey) {
  //   print('[http] getAccountsByKey');

  //   final url = Uri.parse('$baseURL/v1/chain/get_accounts_by_authorizers');
  //   final body = '{ "accounts": [], "keys": ["$publicKey"] }';

  //   return http
  //       .post(url, headers: headers, body: body)
  //       .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
  //             print('result: $body');
  //             // restriction to `active` permission matches ProfileRepository.getAccountPublicKeys
  //             final result =
  //                 List<dynamic>.from(body['accounts'] as List).cast<Map<String, dynamic>>()
  //                   .where((e) => e['permission_name'] as String == 'active')
  //                   .map((e) => e['account_name'] as String).toList().toSet().toList();

  //             result.sort();

  //             return result;
  //           }))
  //       .catchError((dynamic error) => mapHttpError(error));
  // }

