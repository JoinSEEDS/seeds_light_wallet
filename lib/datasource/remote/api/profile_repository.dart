import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/crypto/eosdart/eosdart.dart';
import 'package:seeds/datasource/remote/api/eos_repo/eos_repository.dart';
import 'package:seeds/datasource/remote/api/eos_repo/seeds_eos_actions.dart';
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_scopes.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_tables.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/datasource/remote/model/organization_model.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/datasource/remote/model/referred_accounts_model.dart';
import 'package:seeds/datasource/remote/model/score_model.dart';
import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/ui_constants.dart';

class ProfileRepository extends HttpRepository with EosRepository {
  Future<Result<ProfileModel>> getProfile(String accountName) {
    print('[http] get seeds getProfile $accountName');

    final request = createRequest(
      code: SeedsCode.accountAccounts,
      scope: SeedsCode.accountAccounts.value,
      table: SeedsTable.tableUsers,
      lowerBound: accountName,
      upperBound: accountName,
    );

    return http
        .post(Uri.parse('${remoteConfigurations.activeEOSServerUrl.url}/v1/chain/get_table_rows'),
            headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<ProfileModel>(response, (dynamic body) {
              return ProfileModel.fromJson(body['rows'][0]);
            }))
        .catchError((error) => mapHttpError(error));
  }

  // TODO(Raul): Unify this code with _getAccountPermissions in guardians repo
  // Returns the first active key permission - String
  Future<Result> getAccountPublicKeys(String accountName) async {
    print('[http] getAccountPublicKeys');

    final url = Uri.parse('$host/v1/chain/get_account');
    final body = '{ "account_name": "$accountName" }';

    return http
        .post(url, headers: headers, body: body)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              final List<dynamic> allAccounts = body['permissions'].toList();
              final permissions = allAccounts.map((item) => Permission.fromJson(item)).toList();
              final Permission activePermission = permissions.firstWhere((element) => element.permName == "active");
              final RequiredAuth? activeAuth = activePermission.requiredAuth;
              return activeAuth?.keys?.map((e)=>e?.key).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<TransactionResponse>> updateProfile({
    required String nickname,
    required String image,
    required String story,
    required String roles,
    required String skills,
    required String interests,
    required String accountName,
  }) async {
    print('[eos] update profile');

    final transaction = buildFreeTransaction([
      Action()
        ..account = SeedsCode.accountAccounts.value
        ..name = SeedsEosAction.actionNameUpdate.value
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = permissionActive
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
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse<TransactionResponse>(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  Future<Result<ScoreModel>> getScore({
    required String account,
    SeedsCode contractName = SeedsCode.accountHarvest,
    String? scope,
    required SeedsTable tableName,
    String fieldName = "rank",
  }) async {
    print('[http] get score $account $tableName');

    final scoreURL = Uri.parse('${remoteConfigurations.activeEOSServerUrl.url}/v1/chain/get_table_rows');

    final request = createRequest(
      code: contractName,
      scope: scope ?? contractName.value,
      table: tableName,
      lowerBound: account,
      upperBound: account,
    );

    return http
        .post(scoreURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<ScoreModel>(response, (dynamic body) {
              return ScoreModel.fromJson(json: body, fieldName: fieldName);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<ReferredAccounts>> getReferredAccounts(String accountName) {
    print('[http] get Referred Accounts $accountName');

    final request = createRequest(
      code: SeedsCode.accountAccounts,
      scope: SeedsCode.accountAccounts.value,
      table: SeedsTable.tableRefs,
      lowerBound: accountName,
      upperBound: accountName,
      indexPosition: 2,
      limit: 100,
    );

    return http
        .post(Uri.parse('${remoteConfigurations.activeEOSServerUrl.url}/v1/chain/get_table_rows'),
            headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<ReferredAccounts>(response, (dynamic body) {
              return ReferredAccounts.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<TransactionResponse>> plantSeeds({required double amount, required String accountName}) async {
    print('[eos] plant seeds ($amount)');

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
          'to': SeedsCode.accountHarvest.value,
          'quantity': '${amount.toStringAsFixed(4)} $currencySeedsCode',
          'memo': '',
        }
    ], accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse<TransactionResponse>(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  Future<Result<TransactionResponse>> unplantSeeds({required double amount, required String accountName}) async {
    print('[eos] unplant seeds ($amount)');

    final transaction = buildFreeTransaction([
      Action()
        ..account = SeedsCode.accountHarvest.value
        ..name = SeedsEosAction.actionNameUnplant.value
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = permissionActive
        ]
        ..data = {
          'from': accountName,
          'quantity': '${amount.toStringAsFixed(4)} $currencySeedsCode',
        }
    ], accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse<TransactionResponse>(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  /// This claims unplanted Seeds that are ready to be sent back to the user
  /// Each time a user unplants, a new unplant request is created, with a new request ID
  /// This allows to claim on any number of refunds. The chain will decide how much is ready
  /// to be unplanted and send the funds back to the user.
  Future<Result<TransactionResponse>> claimRefund({required String accountName, required List<int> requestIds}) async {
    print('[eos] claimrefund from: $accountName $requestIds');

    final transaction = buildFreeTransaction(
        List.from(requestIds.map(
          (id) => Action()
            ..account = SeedsCode.accountHarvest.value
            ..name = SeedsEosAction.actionNameClaimRefund.value
            ..authorization = [
              Authorization()
                ..actor = accountName
                ..permission = permissionActive
            ]
            ..data = {
              'from': accountName,
              'request_id': '$id',
            },
        )),
        accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse<TransactionResponse>(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  Future<Result<TransactionResponse>> makeCitizen(String accountName) async {
    return citizenshipAction(accountName: accountName, isMake: true, isCitizen: true);
  }

  Future<Result<TransactionResponse>> makeResident(String accountName) async {
    return citizenshipAction(accountName: accountName, isMake: true, isCitizen: false);
  }

  Future<Result<TransactionResponse>> canCitizen(String accountName) async {
    return citizenshipAction(accountName: accountName, isMake: false, isCitizen: true);
  }

  Future<Result<TransactionResponse>> canResident(String accountName) async {
    return citizenshipAction(accountName: accountName, isMake: false, isCitizen: false);
  }

  Future<Result<TransactionResponse>> citizenshipAction(
      {required String accountName, required bool isMake, required bool isCitizen}) async {
    final String isMakeText = isMake ? "make" : "can";
    final String isCitizenText = isMake ? "citizen" : "resident";

    print('[eos] $isMakeText $isCitizenText');

    final actionName = isMake
        ? isCitizen
            ? SeedsEosAction.actionNameMakecitizen.value
            : SeedsEosAction.actionNameMakeresident.value
        : isCitizen
            ? SeedsEosAction.actionNameCakecitizen.value
            : SeedsEosAction.actionNameCanresident.value;

    final transaction = buildFreeTransaction([
      Action()
        ..account = SeedsCode.accountAccounts.value
        ..name = actionName
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = permissionActive
        ]
        ..data = {
          'user': accountName,
        }
    ], accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse<TransactionResponse>(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  /// Not being used for the moment
  Future<Result<bool>> isDHOMember(String accountName) {
    print('[http] is $accountName DHO member');

    final request = '{"json": true, "code": "trailservice","scope": "$accountName","table": "voters"}';

    return http
        .post(Uri.parse('${remoteConfigurations.activeEOSServerUrl.url}/v1/chain/get_table_rows'),
            headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<bool>(response, (dynamic body) {
              return (body['rows'] as List).isNotEmpty;
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<List<OrganizationModel>>> getOrganizationAccount(String accountName) {
    print('[http] get organization account');

    final request = createRequest(
      code: SeedsCode.accountOrgs,
      scope: SeedsCode.accountOrgs.value,
      lowerBound: accountName,
      upperBound: accountName,
      table: SeedsTable.tableOrganization,
      limit: 10,
    );

    return http
        .post(Uri.parse('$baseURL/v1/chain/get_table_rows'), headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<List<OrganizationModel>>(response, (dynamic body) {
              final List<dynamic> allAccounts = body['rows'].toList();
              return allAccounts.map((i) => OrganizationModel.fromJson(i)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }
}
