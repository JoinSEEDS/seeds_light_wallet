import 'dart:convert';

import 'package:async/async.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_scopes.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';

/// Retrieve token metadata (used for display of currency cards etc) from
/// a table in the token master smart contract (tmastr.seeds)
class TokenModelsRepository extends HttpRepository {
  Future<Result<List<TokenModel>>> getTokenModels(List<String> acceptList, [List<String>? infoList]) async {
    /// imports data from all tokens which are accepted under any of the entries in acceptList
    print("[http] importing token models");
    final v1ChainUrl = Uri.parse(
           'https://api.telosfoundation.io/v1/chain/get_table_rows');
    final idSet = <int>{};
    final useCaseMap = <int, List<String>>{} ;
    /// accumulate accepted token id's in idSet
    /// record valid usecases (from both acceptList and infoList) for each token in useCaseMap
    for(final useCase in acceptList + (infoList ?? [])) {
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
              for (final id in tokenIds) {
                useCaseMap[id] ??= [];
                useCaseMap[id]!.add(useCase);
              }
              if(acceptList.contains(useCase)) {
                idSet.addAll(tokenIds);
              }
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
            /// retrieve entire list of tokens from master list, then filter by idSet
            for (final token in tokens) {
              token['usecases'] = useCaseMap[token['id']];
            }
            return List<TokenModel?>.from(tokens.map((token) =>
                TokenModel.fromJson(token))).whereNotNull().toList();
                /// build a TokenModel from each selected token's metadata
        }))
        .catchError((dynamic error) => mapHttpError(error));
  }

  Future<Result<Map<String,dynamic>>> getSchema() async {
    print('[http] get token master list schema');
    final request = '{"json":true,"code":"${SeedsCode.accountTokenModels.value}", "scope":"${SeedsCode.accountTokenModels.value}","table":"schema"}';

    return http
        .post(Uri.parse('$baseURL/v1/chain/get_table_rows'), headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<Map<String,dynamic>>(response, (dynamic body) {
      return body;
    }))
        .catchError((error) => mapHttpError(error));
  }
}
