import 'package:async/async.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:eosdart/eosdart.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/eos_repository.dart';
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/invite_model.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/datasource/remote/model/transaction_response.dart';
import 'package:seeds/v2/domain-shared/app_constants.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';

class InviteRepository extends NetworkRepository with EosRepository {
  Future<Result> createInvite({
    required double quantity,
    required String inviteHash,
    required String accountName,
  }) async {
    print('[eos] create invite $inviteHash ($quantity)');

    var sowQuantity = 5;
    var transferQuantity = quantity - sowQuantity;

    var transaction = buildFreeTransaction([
      Action()
        ..account = account_token
        ..name = actionNameTransfer
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = permissionActive
        ]
        ..data = {
          'from': accountName,
          'to': account_join,
          'quantity': '${quantity.toStringAsFixed(4)} $currencySeedsCode',
          'memo': '',
        },
      Action()
        ..account = account_join
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
        .then((dynamic response) => mapEosResponse(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  Future<Result> getMembers() {
    print('[http] get members');

    final membersURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    var request = createRequest(code: account_accounts, scope: account_accounts, table: tableUsers, limit: 1000);

    return http
        .post(membersURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              List<dynamic> allAccounts = body['rows'].toList();
              return allAccounts.map((item) => MemberModel.fromJson(item)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> findInvite(String inviteHash) async {
    print('[http] find invite by hash');

    var inviteURL = Uri.parse('$baseURL/v1/chain/get_table_rows');
    // 'https://node.hypha.earth/v1/chain/get_table_rows'; // todo: Why is this still Hypha when config has changed?

    var request = createRequest(
        code: account_join,
        scope: account_join,
        table: tableInvites,
        lowerBound: inviteHash,
        upperBound: inviteHash,
        indexPosition: 2,
        keyType: "sha256");

    return http
        .post(inviteURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              List<dynamic> invite = body['rows'].toList();
              return invite.map((item) => InviteModel.fromJson(item)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }
}
