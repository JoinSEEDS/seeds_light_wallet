// ignore_for_file: directives_ordering

import 'dart:async';

import 'package:async/async.dart';

import 'package:seeds/crypto/eosdart/eosdart.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/eos_repo/eos_repository.dart';
import 'package:seeds/datasource/remote/api/eos_repo/seeds_eos_actions.dart';
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_scopes.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_tables.dart';
import 'package:seeds/datasource/remote/datamappers/toDomainInviteModel.dart';
import 'package:seeds/datasource/remote/model/invite_model.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/ui_constants.dart';

class InviteRepository extends HttpRepository with EosRepository {
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
        ..account = SeedsCode.accountToken.value
        ..name = SeedsEosAction.actionNameTransfer.value
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = permissionActive
        ]
        ..data = {
          'from': accountName,
          'to': SeedsCode.accountJoin.value,
          'quantity': '${quantity.toStringAsFixed(4)} $currencySeedsCode',
          'memo': '',
        },
      Action()
        ..account = SeedsCode.accountJoin.value
        ..name = SeedsEosAction.actionNameInvite.value
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
        .then((dynamic response) => mapEosResponse<TransactionResponse>(response, (Map<String, dynamic> map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  Future<Result<ProfileModel>> getMembers() {
    print('[http] get members');

    final membersURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
        code: SeedsCode.accountAccounts,
        scope: SeedsCode.accountAccounts.value,
        table: SeedsTable.tableUsers,
        limit: 1000);

    return http
        .post(membersURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<ProfileModel>(response, (Map<String, dynamic> body) {
              final List<dynamic> allAccounts = body['rows'] as List;
              return allAccounts.map((item) => ProfileModel.fromJson(item as Map<String, dynamic>)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<List<InviteModel>>> findInvite(String inviteHash) async {
    print('[http] find invite by hash');

    final inviteURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
        code: SeedsCode.accountJoin,
        scope: SeedsCode.accountJoin.value,
        table: SeedsTable.tableInvites,
        lowerBound: inviteHash,
        upperBound: inviteHash,
        indexPosition: 2,
        keyType: "sha256");

    return http
        .post(inviteURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<List<InviteModel>>(response, (Map<String, dynamic> body) {
              final List<dynamic> invite = body['rows'] as List;
              return invite.map((item) => InviteModel.fromJson(item as Map<String, dynamic>)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<List<InviteModel>>> getInvites(String userAccount) async {
    print('[http] find all invites');

    final inviteURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
      code: SeedsCode.accountJoin,
      scope: SeedsCode.accountJoin.value,
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

  Future<Result<TransactionResponse>> cancelInvite({
    required String accountName,
    required String inviteHash,
  }) async {
    print('[eos] cancel invite $inviteHash');

    final transaction = buildFreeTransaction([
      Action()
        ..account = SeedsCode.accountJoin.value
        ..name = SeedsEosAction.actionNameCancelInvite.value
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
        .then((dynamic response) => mapEosResponse<TransactionResponse>(response, (Map<String, dynamic> map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }
}
