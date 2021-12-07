import 'dart:async';

import 'package:async/async.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:eosdart/eosdart.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/eos_repository.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_tables.dart';
import 'package:seeds/datasource/remote/api/network_repository.dart';
import 'package:seeds/datasource/remote/datamappers/toDomainInviteModel.dart';
import 'package:seeds/datasource/remote/model/invite_model.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/app_constants.dart';
import 'package:seeds/domain-shared/ui_constants.dart';

class InviteRepository extends NetworkRepository with EosRepository {
  Future<Result<TransactionResponse>> createInvite({
    required double quantity,
    required String inviteHash,
    required String accountName,
  }) async {
    print('[eos] create invite $inviteHash ($quantity)');

    final sowQuantity = 5;
    final transferQuantity = quantity - sowQuantity;

    final transaction = buildFreeTransaction([
      Action()
        ..account = accountToken
        ..name = actionNameTransfer
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = permissionActive
        ]
        ..data = {
          'from': accountName,
          'to': accountJoin,
          'quantity': '${quantity.toStringAsFixed(4)} $currencySeedsCode',
          'memo': '',
        },
      Action()
        ..account = accountJoin
        ..name = actionNameInvite
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = permissionActive
        ]
        ..data = {
          'sponsor': accountName,
          'transfer_quantity': '${transferQuantity.toStringAsFixed(4)} $currencySeedsCode',
          'sow_quantity': '${sowQuantity.toStringAsFixed(4)} $currencySeedsCode',
          'invite_hash': inviteHash,
        }
    ], accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse<TransactionResponse>(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  Future<Result<MemberModel>> getMembers() {
    print('[http] get members');

    final membersURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(code: accountAccounts, scope: accountAccounts, table: SeedsTable.tableUsers, limit: 1000);

    return http
        .post(membersURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<MemberModel>(response, (dynamic body) {
              final List<dynamic> allAccounts = body['rows'].toList();
              return allAccounts.map((item) => MemberModel.fromJson(item)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<List<InviteModel>>> findInvite(String inviteHash) async {
    print('[http] find invite by hash');

    final inviteURL = Uri.parse('$baseURL/v1/chain/get_table_rows');
    // 'https://node.hypha.earth/v1/chain/get_table_rows'; // todo: Why is this still Hypha when config has changed?

    final request = createRequest(
        code: accountJoin,
        scope: accountJoin,
        table: SeedsTable.tableInvites,
        lowerBound: inviteHash,
        upperBound: inviteHash,
        indexPosition: 2,
        keyType: "sha256");

    return http
        .post(inviteURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<List<InviteModel>>(response, (dynamic body) {
              final List<dynamic> invite = body['rows'].toList();
              return invite.map((item) => InviteModel.fromJson(item)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<List<InviteModel>>> getInvites(String userAccount) async {
    print('[http] find all invites');

    final inviteURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
      code: accountJoin,
      scope: accountJoin,
      table: SeedsTable.tableInvites,
      limit: 200,
      indexPosition: 3,
      lowerBound: userAccount,
      upperBound: userAccount,
    );

    return http
        .post(inviteURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<List<InviteModel>>(response, toDomainInviteModel))
        .catchError((e) => mapHttpError(e));
  }

  Future<Result<InviteModel>> cancelInvite({
    required String accountName,
    required String inviteHash,
  }) async {
    print('[eos] cancel invite $inviteHash');

    final transaction = buildFreeTransaction([
      Action()
        ..account = accountJoin
        ..name = actionNameCancelInvite
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = permissionActive
        ]
        ..data = {
          'sponsor': accountName,
          'invite_hash': inviteHash,
        }
    ], accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse<InviteModel>(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }
}
