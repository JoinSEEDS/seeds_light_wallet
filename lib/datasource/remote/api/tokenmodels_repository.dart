import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_scopes.dart';

/// Retrieve token metadata (used for display of currency cards etc) from
/// a table in the token master smart contract (tmastr.seeds)
class TokenModelsRepository extends HttpRepository {

  Future<Result<List<int>>> getAcceptedTokenIds(String useCase) async {
    final request = '''
    {
      "json":true,
      "code":"${SeedsCode.accountTokenModels.value}",
      "scope":"$useCase",
      "table":"acceptances",
      "limit":100
    }
    ''';
    return http
        .post(Uri.parse('$baseURL/v1/chain/get_table_rows'), headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<List<int>>(response, (dynamic body) {
      final acceptances = body['rows'].toList();
      final tokenIds = List<int>.from(acceptances.map((row) => row['token_id']).toList());
      return tokenIds;
    }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<Map<String,dynamic>>> getMasterTokenTable() async {
    print('[http] get token master list');
    final request = '''
    {
      "json":true,
      "code":"${SeedsCode.accountTokenModels.value}",
      "scope":"${SeedsCode.accountTokenModels.value}",
      "table":"tokens",
      "limit":100
    }
    ''';
    return http
        .post(Uri.parse('$baseURL/v1/chain/get_table_rows'), headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<Map<String,dynamic>>(response, (dynamic body) {
      return body;
    }))
        .catchError((error) => mapHttpError(error));
  }


  Future<Result<Map<String,dynamic>>> getSchema() async {
    print('[http] get token master list schema');
    final request = '''
    {
      "json":true,
      "code":"${SeedsCode.accountTokenModels.value}",
      "scope":"${SeedsCode.accountTokenModels.value}",
      "table":"schema",
      "limit":1
    }
    ''';
    return http
        .post(Uri.parse('$baseURL/v1/chain/get_table_rows'), headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<Map<String,dynamic>>(response, (dynamic body) {
      return body;
    }))
        .catchError((error) => mapHttpError(error));
  }
}
