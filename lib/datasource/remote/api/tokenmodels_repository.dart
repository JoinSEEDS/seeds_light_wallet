import 'dart:convert';

import 'package:async/async.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_scopes.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';

class TokenModelsRepository extends HttpRepository {
  Future<Result<List<TokenModel>>> getTokenModels(List<String> useCaseList) async {
    print("[http] update token models");
    final v1ChainUrl = Uri.parse(
           'https://api.telosfoundation.io/v1/chain/get_table_rows');
    final idSet = <int>{};
    for(final useCase in useCaseList) {
      final String request = '''
      {
        "code":"${SeedsCode.accountTokenModels.value}",
        "table":"acceptances",
        "scope":"$useCase",
        "json":true
      }
      ''';
      await http
          .post(v1ChainUrl, headers: headers, body: request)
          .then((http.Response response)  {
              final acceptances = json.decode(response.body)['rows'].toList();
              final tokenIds = List<int>.from(acceptances.map((row) => row['token_id']).toList());
              idSet.addAll(tokenIds);
          });
    }
      final String request = '''
      {
        "code":"${SeedsCode.accountTokenModels.value}",
        "table":"tokens",
        "scope":"${SeedsCode.accountTokenModels.value}",
        "json":true
      }
      ''';
      return http
          .post(v1ChainUrl, headers: headers, body: request)
          .then((http.Response response) => mapHttpResponse<List<TokenModel>>(response, (dynamic body) {
                 final tokens = List<Map<String,dynamic>>.from(body['rows'].toList()
                     .where((row) => idSet.contains(row['id'])));
                 return List<TokenModel?>.from(tokens.map((token) =>
                    TokenModel.fromJson(token))).whereNotNull().toList();
             }))
          .catchError((dynamic error) => mapHttpError(error));
  }
}
