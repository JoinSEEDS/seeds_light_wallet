import 'dart:async';

import 'package:async/async.dart';
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
        .then((response) => mapEosResponse<TransactionResponse>(response, (body) => TransactionResponse.fromJson(body)))
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
        .then((response) => mapEosResponse<TransactionResponse>(response, (body) => TransactionResponse.fromJson(body)))
        .catchError((error) => mapEosError(error));
  }

  Future<Result<List<FlagModel>>> getFlagsFrom(String from) {
    final url = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
      code: SeedsCode.accountAccounts,
      scope: SeedsCode.accountAccounts.value,
      table: SeedsTable.tableFlags,
      // ignore: avoid_redundant_argument_values
      keyType: "i64",
      indexPosition: 2,
      lowerBound: from,
      upperBound: from,
      limit: 200,
    );

    print("request $request");

    return http
        .post(url, body: request)
        .then((response) => mapHttpResponse<List<FlagModel>>(response, (body) {
              final List<dynamic> items = body['rows'].toList();
              return items.map((item) => FlagModel.fromJson(item)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<List<FlagModel>>> getFlagsTo(String to) {
    final url = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
      code: SeedsCode.accountAccounts,
      scope: SeedsCode.accountAccounts.value,
      table: SeedsTable.tableFlags,
      // ignore: avoid_redundant_argument_values
      keyType: "i64",
      indexPosition: 3,
      lowerBound: to,
      upperBound: to,
      limit: 200,
    );

    return http
        .post(url, body: request)
        .then((response) => mapHttpResponse<List<FlagModel>>(response, (body) {
              final List<dynamic> items = body['rows'].toList();
              return items.map((item) => FlagModel.fromJson(item)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }
}
