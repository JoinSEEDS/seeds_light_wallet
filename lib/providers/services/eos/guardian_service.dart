import 'package:eosdart/eosdart.dart';
import 'package:flutter/widgets.dart' show BuildContext;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/config.dart';
import 'package:seeds/constants/http_mock_response.dart';
import 'package:seeds/utils/extensions/response_extension.dart';

class GuardianEosService {
  String privateKey;
  String accountName;
  String baseURL = Config.defaultEndpoint;
  EOSClient client;
  bool mockEnabled;

  static GuardianEosService of(BuildContext context, {bool listen = true}) => Provider.of(context, listen: listen);

  Transaction buildFreeTransaction(List<Action> actions) {
    List<Authorization> freeAuth = [
      Authorization()
        ..actor = "harvst.seeds"
        ..permission = "payforcpu",
      Authorization()
        ..actor = accountName
        ..permission = "active"
    ];

    Action freeAction = Action()
      ..account = "harvst.seeds"
      ..name = 'payforcpu'
      ..authorization = freeAuth
      ..data = {"account": accountName};

    var transaction = Transaction()
      ..actions = [
        freeAction,
        ...actions,
      ];

    return transaction;
  }

// method to properly convert RequiredAuth to JSON - the library doesn't work
  Map<String, dynamic> requiredAuthToJson(RequiredAuth instance) => <String, dynamic>{
        'threshold': instance.threshold,
        'keys': List<dynamic>.from(instance.keys.map((e) => e.toJson())),
        'accounts': instance.accounts,
        'waits': instance.waits
      };

  Future<dynamic> updatePermission(Permission permission) async {
    print("[eos] update permission ${permission.permName}");

    if (mockEnabled) return HttpMockResponse.transactionResult;

    var permissionsMap = requiredAuthToJson(permission.requiredAuth);

    print("converted JSPN: ${permissionsMap.toString()}");

    Transaction transaction = buildFreeTransaction([
      Action()
        ..account = "eosio"
        ..name = "updateauth"
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = "owner"
        ]
        ..data = {
          "account": accountName,
          "permission": permission.permName,
          "parent": permission.parent,
          "auth": permissionsMap
        }
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> initGuardians(List<String> guardians) async {
    print("[eos] init guardians");

    if (mockEnabled) return HttpMockResponse.transactionResult;

    Transaction transaction = buildFreeTransaction([
      Action()
        ..account = "guard.seeds"
        ..name = "init"
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = "active"
        ]
        ..data = {
          "user_account": accountName,
          "guardian_accounts": guardians,
          "time_delay_sec": Duration(days: 1).inSeconds,
        }
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> recoverAccount(String userAccount, String publicKey) async {
    print("[eos] recover account $userAccount");

    if (mockEnabled) return HttpMockResponse.transactionResult;

    Transaction transaction = buildFreeTransaction([
      Action()
        ..account = "guard.seeds"
        ..name = "recover"
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = "owner"
        ]
        ..data = {
          "guardian_account": accountName,
          "user_account": userAccount,
          "new_public_key": publicKey,
        }
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> cancelRecovery() async {
    print("[eos] cancel recovery $accountName");

    if (mockEnabled) return HttpMockResponse.transactionResult;

    Transaction transaction = buildFreeTransaction([
      Action()
        ..account = "guard.seeds"
        ..name = "cancel"
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = "owner"
        ]
        ..data = {"user_account": accountName}
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> claimRecoveredAccount(String userAccount) async {
    print("[eos] claim recovered account $userAccount");
    String applicationAccount = Config.onboardingAccountName;

    if (mockEnabled) return HttpMockResponse.transactionResult;
    List<Authorization> auth = [
      Authorization()
        ..actor = applicationAccount
        ..permission = "application"
    ];
    Transaction transaction = buildFreeTransaction([
      Action()
        ..account = "guard.seeds"
        ..name = "claim"
        ..authorization = auth
        ..data = {"user_account": userAccount}
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<List<Permission>> getAccountPermissions() async {
    print("[http] get account permissions");

    if (mockEnabled) {
      return Future.value(HttpMockResponse.accountPermissions);
    }

    final String url = "$baseURL/v1/chain/get_account";
    final String body = '{ "account_name": "$accountName" }';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(url, headers: headers, body: body);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      List<Permission> permissions =
          List<Permission>.from(body["permissions"].map((item) => Permission.fromJson(item)).toList());

      return permissions;
    } else {
      print('Cannot fetch account permissions...');
      return List<Permission>();
    }
  }

  Future<void> setGuardianPermission() async {
    final currentPermissions = await getAccountPermissions();

    final ownerPermission = currentPermissions.firstWhere((item) => item.permName == "owner");

    ownerPermission.requiredAuth.accounts.add({
      "weight": ownerPermission.requiredAuth.threshold,
      "permission": {"actor": "guard.seeds", "permission": "eosio.code"}
    });

    await updatePermission(ownerPermission);
  }

  Future<void> removeGuardianPermission() async {
    final currentPermissions = await getAccountPermissions();

    final ownerPermission = currentPermissions.firstWhere((item) => item.permName == "owner");

    List<dynamic> newAccounts = [];
    for (Map<String, dynamic> acct in ownerPermission.requiredAuth.accounts) {
      if (acct["permission"]["actor"] == "guard.seeds") {
        //print("found guardian permission");
      } else {
        newAccounts.add(acct);
      }
    }
    ownerPermission.requiredAuth.accounts = newAccounts;
    await updatePermission(ownerPermission);
  }
}
