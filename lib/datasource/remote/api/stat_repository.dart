import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/model/stat_model.dart';

class StatRepository extends HttpRepository {
  Future<Result<StatModel>> getTokenStat(
      {required String tokenContract, required String symbol}) {
    print('[http] get getTokenStat for $symbol');

    final String request = '''
    {
      "code":"$tokenContract",
      "table": "stat",
      "scope":"$symbol",
      "json": "true"
    }
    ''';

    final statURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    return http
        .post(statURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<StatModel>(response, (Map<String, dynamic> body) {
              return StatModel.fromJson(body);
            }))
        .catchError((dynamic error) => mapHttpError(error));
  }
}
