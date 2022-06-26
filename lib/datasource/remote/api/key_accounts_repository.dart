import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';

class KeyAccountsRepository extends HttpRepository {
  Future<Result<dynamic>> getKeyAccounts(String publicKey) {
    print('[http] getKeyAccounts');

    final url = Uri.parse('$baseURL/v1/history/get_key_accounts');
    final body = '{ "public_key": "$publicKey" }';

    return http
        .post(url, body: body)
        .then((response) => mapHttpResponse(response, (body) {
              final result = List<String>.from(body['account_names']);
              result.sort();
              return result;
            }))
        .catchError((error) => mapHttpError(error));
  }
}
