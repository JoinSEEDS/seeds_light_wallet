import 'dart:async';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/crypto/eosdart/eosdart.dart';
import 'package:seeds/datasource/remote/api/eos_repo/eos_repository.dart';
import 'package:seeds/datasource/remote/api/eos_repo/seeds_eos_actions.dart';
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_scopes.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_tables.dart';
import 'package:seeds/datasource/remote/model/region_member_model.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/datasource/remote/model/seeds_settings_model.dart';
import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/ui_constants.dart';

class RegionRepository extends HttpRepository with EosRepository {
  Future<Result<List<RegionModel>>> getRegions() {
    print('[http] get regions');

    final membersURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
      code: SeedsCode.accountRegion,
      scope: SeedsCode.accountRegion.value,
      table: SeedsTable.tableRegions,
      limit: 1000,
    );

    return http
        .post(membersURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<List<RegionModel>>(response, (dynamic body) {
              final List<dynamic> items = body['rows'].toList();
              return items.map((item) => RegionModel.fromJson(item)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<List<RegionMemberModel>>> getRegionMembers(String region) {
    print('[http] get region members for $region');

    final membersURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
      code: SeedsCode.accountRegion,
      scope: SeedsCode.accountRegion.value,
      table: SeedsTable.tableRegionMembers,
      indexPosition: 2,
      // ignore: avoid_redundant_argument_values
      keyType: 'i64',
      lowerBound: region,
      upperBound: region,
      limit: 1000,
    );

    return http
        .post(membersURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<List<RegionMemberModel>>(response, (dynamic body) {
              final List<dynamic> items = body['rows'].toList();
              return items.map((item) => RegionMemberModel.fromJson(item)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }

  ///
  /// Create Region
  ///
  /// This action will transfer 1,000 Seeds region fee, then create a region with the name
  /// regionAccount must end in ".rgn", e.g. bali.rgn and it must be a valid Telos account name
  ///
  /// Note: The region fee is variable, see getRegionFee().
  ///
  Future<Result<TransactionResponse>> create({
    required String userAccount,
    required String regionAccount,
    required String title,
    required String description,
    required double latitude,
    required double longitude,
    required String regionAddress,
    double regionFee = 1000.0,
  }) async {
    print('[eos] create region $regionAccount');

    final transaction = buildFreeTransaction([
      Action()
        ..account = SeedsCode.accountToken.value
        ..name = SeedsEosAction.actionNameTransfer.value
        ..authorization = [
          Authorization()
            ..actor = userAccount
            ..permission = permissionActive
        ]
        ..data = {
          'from': userAccount,
          'to': SeedsCode.accountRegion.value,
          'quantity': '${regionFee.toStringAsFixed(4)} $currencySeedsCode',
          'memo': 'Create region fee',
        },
      Action()
        ..account = SeedsCode.accountRegion.value
        ..name = SeedsEosAction.actionNameCreateRegion.value
        ..authorization = [
          Authorization()
            ..actor = userAccount
            ..permission = permissionActive
        ]
        ..data = {
          'founder': userAccount,
          'rgnaccount': regionAccount,
          'title': title,
          'description': description,
          'locationJson': regionAddress,
          'latitude': latitude,
          'longitude': longitude
        },
    ], userAccount);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse<TransactionResponse>(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  ///
  /// Update Region
  ///
  /// Only the founder can update a region
  ///
  Future<Result<TransactionResponse>> update({
    required String userAccount,
    required String regionAccount,
    required String title,
    required String description,
    required double latitude,
    required double longitude,
  }) async {
    print('[eos] update region $regionAccount');

    final transaction = buildFreeTransaction([
      Action()
        ..account = SeedsCode.accountRegion.value
        ..name = SeedsEosAction.actionNameUpdateRegion.value
        ..authorization = [
          Authorization()
            ..actor = userAccount
            ..permission = permissionActive
        ]
        ..data = {
          'rgnaccount': regionAccount,
          'title': title,
          'description': description,
          'locationJson': '{lat:$latitude,lon:$longitude}',
          'latitude': latitude,
          'longitude': longitude
        },
    ], userAccount);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse<TransactionResponse>(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  ///
  /// Join a region
  ///
  Future<Result<TransactionResponse>> join({
    required String region,
    required String userAccount,
  }) async {
    print('[eos] join region $region');

    final transaction = buildFreeTransaction([
      Action()
        ..account = SeedsCode.accountRegion.value
        ..name = SeedsEosAction.actionNameJoinRegion.value
        ..authorization = [
          Authorization()
            ..actor = userAccount
            ..permission = permissionActive
        ]
        ..data = {
          'region': region,
          'account': userAccount,
        },
    ], userAccount);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse<TransactionResponse>(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  ///
  /// Leave a region
  ///
  Future<Result<TransactionResponse>> leave({
    required String region,
    required String userAccount,
  }) async {
    print('[eos] leave region $region');

    final transaction = buildFreeTransaction([
      Action()
        ..account = SeedsCode.accountRegion.value
        ..name = SeedsEosAction.actionNameLeaveRegion.value
        ..authorization = [
          Authorization()
            ..actor = userAccount
            ..permission = permissionActive
        ]
        ..data = {
          'region': region,
          'account': userAccount,
        },
    ], userAccount);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse<TransactionResponse>(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  // return the region fee in Seeds - fee needed to create a region
  Future<Result<double>> getRegionFee() {
    print('[http] get region fee');

    final membersURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
      code: SeedsCode.accountSettgs,
      scope: SeedsCode.accountSettgs.value,
      lowerBound: 'region.fee',
      upperBound: 'region.fee',
      table: SeedsTable.tableConfig,
      limit: 2,
    );

    return http
        .post(membersURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<double>(response, (dynamic body) {
              final List<dynamic> items = body['rows'].toList();
              final setting = SeedsSettingsModel.fromJson(items[0]);
              return setting.value / 10000.0; // settings values are stored with 10000 multiplier
            }))
        .catchError((error) => mapHttpError(error));
  }

  // Not implemented actions:
  // ACTION addrole(name region, name admin, name account, name role);
  // ACTION removerole(name region, name admin, name account);
  // ACTION leaverole(name region, name account);
  // ACTION removemember(name region, name admin, name account);
  // ACTION setfounder(name region, name founder, name new_founder);
  // ACTION removergn(name region);
  // ACTION createacct(name region, string publicKey);

}
