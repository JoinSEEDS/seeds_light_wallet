import 'dart:async';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/crypto/eosdart/eosdart.dart';
import 'package:seeds/datasource/remote/api/eos_repo/eos_repository.dart';
import 'package:seeds/datasource/remote/api/eos_repo/seeds_eos_actions.dart';
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_scopes.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_tables.dart';
import 'package:seeds/datasource/remote/model/flag_model.dart';
import 'package:seeds/datasource/remote/model/transaction_response.dart';

class FlagRepository extends HttpRepository with EosRepository {
  Future<Result<TransactionResponse>> flag({
    required String from,
    required String to,
  }) async {
    print('[eos] flag $to');

    final transaction = buildFreeTransaction([
      Action()
        ..account = SeedsCode.accountAccounts.value
        ..name = SeedsEosAction.actionNameFlag.value
        ..authorization = [
          Authorization()
            ..actor = from
            ..permission = permissionActive
        ]
        ..data = {
          'from': from,
          'to': to,
        },
    ], from);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse<TransactionResponse>(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  Future<Result<TransactionResponse>> removeFlag({
    required String from,
    required String to,
  }) async {
    print('[eos] remove flag on $to');

    final transaction = buildFreeTransaction([
      Action()
        ..account = SeedsCode.accountAccounts.value
        ..name = SeedsEosAction.actionNameRemoveFlag.value
        ..authorization = [
          Authorization()
            ..actor = from
            ..permission = permissionActive
        ]
        ..data = {
          'from': from,
          'to': to,
        },
    ], from);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse<TransactionResponse>(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  /// flags for accountName
  Future<Result<List<FlagModel>>> getFlags(String accountName) {
    final url = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
      code: SeedsCode.accountAccounts,
      scope: accountName,
      table: SeedsTable.tableFlagPoints,
      limit: 200,
    );

    return http
        .post(url, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<List<FlagModel>>(response, (dynamic body) {
              final List<dynamic> items = body['rows'].toList();
              return items.map((item) => FlagModel.fromJson(item)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }

  /// flags by accountname - we will need to make a call to history for this
  /// TBD

}
