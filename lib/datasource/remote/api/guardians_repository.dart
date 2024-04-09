import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/crypto/dart_esr/dart_esr.dart' as esr;
import 'package:seeds/crypto/eosdart/eosdart.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/eos_repo/eos_repository.dart';
import 'package:seeds/datasource/remote/api/eos_repo/seeds_eos_actions.dart';
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_scopes.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_tables.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/datasource/remote/model/account_guardians_model.dart';
import 'package:seeds/datasource/remote/model/user_recover_model.dart';
import 'package:seeds/domain-shared/app_constants.dart';

class GuardiansRepository extends EosRepository with HttpRepository {
  /// Step 1 in the guardian set up - call this to allow the guard.seeds contract to
  /// change the key.
  ///
  /// Before the guardian contract can act on a recovery request, the users account needs to
  /// allow the guardian contract to change the keys.
  ///
  Future<Result> setGuardianPermission() async {
    print('[eos] setGuardianPermission');

    final Result currentPermissions = await _getAccountPermissions();
    // Error Fetching permissions.
    if (currentPermissions.isError) {
      print('[eos] currentPermissions.isError Error fetching permissions');
      return currentPermissions;
    }

    final Permission ownerPermission =
        (currentPermissions.asValue!.value as List<Permission>).firstWhere((item) => item.permName == 'owner');

    // Check if permissions are already set?
    // ignore: unnecessary_cast
    for (final Map<String, dynamic>? acct in (ownerPermission.requiredAuth?.accounts ?? []) as List<Map<String, dynamic>>) {
      if (acct?['permission']['actor'] == SeedsCode.accountGuards.value) {
        print('permission already set, doing nothing');
        return currentPermissions;
      }
    }

    ownerPermission.requiredAuth?.accounts?.add({
      'weight': ownerPermission.requiredAuth!.threshold,
      'permission': {'actor': SeedsCode.accountGuards.value, 'permission': 'eosio.code'}
    });

    return _updatePermission(ownerPermission);
  }

  /// Step 2 setting up guardians - set the guardians for an account
  ///
  /// guardians - list of Seeds account names that are the guardians - 3, 4, or 5 elements.
  ///
  /// Will fail when it's already set up - in that case, call cancelGuardians first.
  ///
  Future<Result> initGuardians(List<String> guardians) async {
    print('[eos] init guardians: $guardians');

    final accountName = settingsStorage.accountName;

    final actions = [
      Action()
        ..account = SeedsCode.accountGuards.value
        ..name = SeedsEosAction.actionNameInit.value
        ..data = {
          'user_account': accountName,
          'guardian_accounts': guardians,
          'time_delay_sec': guardianRecoveryTimeDelaySec,
        }
    ];

    for (final action in actions) {
      action.authorization = [
        Authorization()
          ..actor = accountName
          ..permission = permissionActive
      ];
    }

    final transaction = buildFreeTransaction(actions, accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse(response, (dynamic map) {
              return response["transaction_id"];
            }))
        .catchError((error) => mapEosError(error));
  }

  /// Claim recovered account for user - this switches the new public key live at the end of the
  /// recovery process.
  ///
  /// This can be called without logging in - the assumption is that the user lost their key,
  /// asked for recovery, was recovered, waited 24 hours for the time lock - and then calls this
  /// method to regain access.
  ///
  Future<Result> claimRecoveredAccount(String userAccount) async {
    print('[eos] claim recovered account $userAccount');

    final actions = [
      Action()
        ..account = SeedsCode.accountGuards.value
        ..name = SeedsEosAction.actionNameClaim.value
        ..data = {'user_account': userAccount}
    ];

    for (final action in actions) {
      action.authorization = [
        Authorization()
          ..actor = SeedsCode.accountGuards.value
          ..permission = permissionApplication
      ];
    }

    final transaction = Transaction()
      ..actions = [
        ...actions,
      ];

    return EOSClient(baseURL, 'v1', privateKeys: [onboardingPrivateKey])
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse(response, (dynamic map) {
              return response["transaction_id"];
            }))
        .catchError((error) => mapEosError(error));
  }

  /// Cancel guardians.
  ///
  /// This cancels any recovery currently in process, and removes all guardians
  ///
  Future<Result> cancelGuardians() async {
    final accountName = settingsStorage.accountName;
    print('[eos] cancel recovery $accountName');

    final actions = [
      Action()
        ..account = SeedsCode.accountGuards.value
        ..name = SeedsEosAction.actionNameCancel.value
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = permissionOwner
        ]
        ..data = {'user_account': accountName}
    ];

    final transaction = buildFreeTransaction(actions, accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse(response, (dynamic map) {
              return response["transaction_id"];
            }))
        .catchError((error) => mapEosError(error));
  }

  /// Recover an account via the key guardian system
  ///
  /// userAcount - the account to recovery, iE current user is a guardian for userAccount
  /// publicKey - the new public key on the account once the recovery is complete
  ///
  /// When 2 or 3 of the guardians call this function, the account can be recovered with claim
  ///
  Future<Result> recoverAccount(String userAccount, String publicKey) async {
    print('[eos] recover account $userAccount');

    final accountName = settingsStorage.accountName;

    final actions = [
      Action()
        ..account = SeedsCode.accountGuards.value
        ..name = SeedsEosAction.actionNameRecover.value
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = permissionOwner
        ]
        ..data = {
          'guardian_account': accountName,
          'user_account': userAccount,
          'new_public_key': publicKey,
        }
    ];

    final transaction = buildFreeTransaction(actions, accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse(response, (dynamic map) {
              return response["transaction_id"];
            }))
        .catchError((error) => mapEosError(error));
  }

  Future<Result<dynamic>> _getAccountPermissions() async {
    print('[http] get account permissions');
    final accountName = settingsStorage.accountName;

    final url = Uri.parse('$baseURL/v1/chain/get_account');
    final body = '{ "account_name": "$accountName" }';

    return http
        .post(url, headers: headers, body: body)
        .then((http.Response response) => mapHttpResponse(response, (Map<String, dynamic> body) {
              final List<dynamic> allAccounts = body['permissions'] as List;
              return allAccounts.map((item) => Permission.fromJson(item as Map<String, dynamic>)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<dynamic>>_updatePermission(Permission permission) async {
    print('[eos] update permission ${permission.permName}');

    final permissionsMap = _requiredAuthToJson(permission.requiredAuth!);

    print('converted JSON: ${permissionsMap.toString()}');
    final accountName = settingsStorage.accountName;

    final actions = [
      Action()
        ..account = SeedsCode.accountEosio.value
        ..name = SeedsEosAction.actionNameUpdateauth.value
        ..data = {
          'account': accountName,
          'permission': permission.permName,
          'parent': permission.parent,
          'auth': permissionsMap
        }
    ];

    for (final action in actions) {
      action.authorization = [
        Authorization()
          ..actor = accountName
          ..permission = permissionOwner
      ];
    }

    final transaction = buildFreeTransaction(actions, accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse(response, (dynamic map) {
              return response["transaction_id"];
            }))
        .catchError((error) => mapEosError(error));
  }

  Future<Result<dynamic>> getAccountRecovery(String accountName) async {
    print('[http] get account recovery $accountName');

    final String requestURL = "$baseURL/v1/chain/get_table_rows";

    final String request = createRequest(
        code: SeedsCode.accountGuards,
        scope: SeedsCode.accountGuards.value,
        table: SeedsTable.tableRecover,
        lowerBound: accountName,
        upperBound: accountName);

    return http
        .post(Uri.parse(requestURL), headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              final rows = body["rows"] as List<dynamic>;
              return UserRecoversModel.fromTableRows(rows);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<dynamic>> getAccountGuardians(String accountName) async {
    print('[http] get account guardians');

    final String requestURL = "$baseURL/v1/chain/get_table_rows";

    final String request = createRequest(
      code: SeedsCode.accountGuards,
      scope: SeedsCode.accountGuards.value,
      table: SeedsTable.tableGuards,
      lowerBound: accountName,
      upperBound: accountName,
    );

    return http
        .post(Uri.parse(requestURL), headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              final rows = body["rows"] as List<Map<String, dynamic>>;
              return UserGuardiansModel.fromTableRows(rows);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<dynamic>> generateRecoveryRequest(String accountName, String publicKey) async {
    print('[ESR] generateRecoveryRequest: $accountName publicKey: ($publicKey)');

    final List<esr.Authorization> auth = [esr.ESRConstants.PlaceholderAuth];

    final Map<String, String> data = {
      'guardian_account': esr.ESRConstants.PlaceholderName,
      'user_account': accountName,
      'new_public_key': publicKey,
    };

    final esr.Action action = esr.Action()
      ..account = SeedsCode.accountGuards.value
      ..name = 'recover'
      ..authorization = auth
      ..data = data;

    final esr.SigningRequestCreateArguments args = esr.SigningRequestCreateArguments(action: action, chainId: chainId);

    return esr.SigningRequestManager.create(args,
            options: esr.defaultSigningRequestEncodingOptions(
              nodeUrl: remoteConfigurations.hyphaEndPoint,
            ))
        .then((esr.SigningRequestManager response) => ValueResult(response.encode()))
        // ignore: return_of_invalid_type_from_catch_error
        .catchError((error) => mapEosError(error));
  }
}

// method to properly convert RequiredAuth to JSON - the library doesn't work
Map<String, dynamic> _requiredAuthToJson(RequiredAuth instance) => <String, dynamic>{
      'threshold': instance.threshold,
      'keys': List<dynamic>.from(instance.keys!.map((e) => e?.toJson())),
      'accounts': instance.accounts,
      'waits': instance.waits
    };
