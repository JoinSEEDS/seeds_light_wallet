import 'package:async/async.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:eosdart/eosdart.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/eos_repository.dart';
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/datasource/remote/model/score_model.dart';
import 'package:seeds/v2/datasource/remote/model/transaction_response.dart';
import 'package:seeds/v2/datasource/remote/model/referred_accounts_model.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';

export 'package:async/src/result/result.dart';

class ProfileRepository extends NetworkRepository with EosRepository {
  Future<Result> getProfile(String accountName) {
    print('[http] get seeds getProfile $accountName');

    var request =
        '{"json":true,"code":"accts.seeds","scope":"accts.seeds","table":"users","table_key":"","lower_bound":" $accountName","upper_bound":" $accountName","index_position":1,"key_type":"i64","limit":1,"reverse":false,"show_payer":false}';

    return http
        .post(Uri.parse('${remoteConfigurations.activeEOSServerUrl.url}/v1/chain/get_table_rows'),
            headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return ProfileModel.fromJson(body['rows'][0]);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> updateProfile({
    String? nickname,
    String? image,
    String? story,
    String? roles,
    String? skills,
    String? interests,
    String? accountName,
  }) async {
    print('[eos] update profile');

    var transaction = buildFreeTransaction([
      Action()
        ..account = 'accts.seeds'
        ..name = 'update'
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = 'active'
        ]
        ..data = {
          'user': accountName,
          'type': 'individual',
          'nickname': nickname,
          'image': image,
          'story': story,
          'roles': roles,
          'skills': skills,
          'interests': interests
        }
    ], accountName);

    return buildEosClient()
        .pushTransaction(transaction, broadcast: true)
        .then((dynamic response) => mapEosResponse(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  Future<Result> getScore(String accountName) async {
    print('[http] get score $accountName');

    final scoreURL = Uri.parse('${remoteConfigurations.activeEOSServerUrl.url}/v1/chain/get_table_rows');

    var request =
        '{"json":true,"code":"harvst.seeds","scope":"harvst.seeds","table":"harvest","table_key":"","lower_bound":" $accountName","upper_bound":" $accountName","index_position":1,"key_type":"i64","limit":"1","reverse":false,"show_payer":false}';

    return http
        .post(scoreURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return ScoreModel.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> getReferredAccounts(String accountName) {
    print('[http] get Referred Accounts $accountName');

    var request =
        '{"json":true,"code":"accts.seeds","scope":"accts.seeds","table":"refs","table_key":"","lower_bound":" $accountName","upper_bound":" $accountName","index_position":2,"key_type":"i64","limit":100,"reverse":false,"show_payer":false}';

    return http
        .post(Uri.parse('${remoteConfigurations.activeEOSServerUrl.url}/v1/chain/get_table_rows'),
            headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return ReferredAccounts.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> plantSeeds({double? amount, String? accountName}) async {
    print('[eos] plant seeds ($amount)');

    var transaction = buildFreeTransaction([
      Action()
        ..account = 'token.seeds'
        ..name = 'transfer'
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = 'active'
        ]
        ..data = {
          'from': accountName,
          'to': 'harvst.seeds',
          'quantity': '${amount!.toStringAsFixed(4)} $currencySeedsCode',
          'memo': '',
        }
    ], accountName);

    return buildEosClient()
        .pushTransaction(transaction, broadcast: true)
        .then((dynamic response) => mapEosResponse(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  Future<Result> isDHOMember(String accountName) {
    print('[http] is $accountName DHO member');

    var request = '{"json": true, "code": "trailservice","scope": "$accountName","table": "voters"}';

    return http
        .post(Uri.parse('${remoteConfigurations.activeEOSServerUrl.url}/v1/chain/get_table_rows'),
            headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return (body['rows'] as List).isNotEmpty;
            }))
        .catchError((error) => mapHttpError(error));
  }
}
