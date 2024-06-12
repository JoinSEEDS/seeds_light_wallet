import 'dart:async';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/crypto/eosdart/eosdart.dart';
import 'package:seeds/datasource/remote/api/eos_repo/eos_repository.dart';
import 'package:seeds/datasource/remote/api/eos_repo/seeds_eos_actions.dart';
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_smart_contract_accounts.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_tables.dart';
import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/datasource/remote/model/vouch_model.dart';

class VouchRepository extends HttpRepository with EosRepository {
  Future<Result<TransactionResponse>> vouch({
    required String accountName,
    required String vouchee,
  }) async {
    print('[eos] vouch for $vouchee');

    final transaction = buildFreeTransaction([
      Action()
        ..account = SeedsCode.accountAccounts.value
        ..name = SeedsEosAction.actionNameVouch.value
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = permissionActive
        ]
        ..data = {
          'sponsor': accountName,
          'account': vouchee,
        },
    ], accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse<TransactionResponse>(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  /// users where accountName is sponsor - who accountname vouched for
  Future<Result<List<VouchModel>>> getVouchees(String accountName) => _getVouches(accountName, true);

  /// users who are sponsors for accountName
  Future<Result<List<VouchModel>>> getSponsors(String accountName) => _getVouches(accountName, false);

  Future<Result<List<VouchModel>>> _getVouches(String accountName, bool isSponsor) {
    print('[http] users where $accountName ($isSponsor ? "is sponsor" : "was sponsored")');

    final membersURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
      code: SeedsCode.accountAccounts,
      scope: SeedsCode.accountAccounts.value,
      indexPosition: isSponsor ? 3 : 2,
      lowerBound: accountName,
      upperBound: accountName,
      table: SeedsTable.tableVouches,
      limit: 200,
    );

    return http
        .post(membersURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<List<VouchModel>>(response, (dynamic body) {
              print("result $isSponsor: $body");
              final List<dynamic> items = body['rows'].toList();
              return items.map((item) => VouchModel.fromJson(item)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }
}
