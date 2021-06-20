import 'package:dart_esr/dart_esr.dart' as esr;
import 'package:eosdart/eosdart.dart';
import 'package:flutter/widgets.dart' show BuildContext;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/config.dart';
import 'package:seeds/constants/http_mock_response.dart';
import 'package:seeds/utils/extensions/response_extension.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_remote_config.dart';

String chain_id = '4667b205c6838ef70ff7988f6e8257e8be0e1284a2f59699054a018f743b1d11';

class EosService {
  String? privateKey;
  String? accountName;
  String? baseURL = remoteConfigurations.defaultEndPointUrl;
  String cpuPrivateKey = Config.cpuPrivateKey;
  late EOSClient client;
  late bool mockEnabled;

  static EosService of(BuildContext context, {bool listen = true}) => Provider.of(context, listen: listen);

  void update({
    userPrivateKey,
    userAccountName,
    nodeEndpoint,
    bool enableMockTransactions = false,
  }) {
    privateKey = userPrivateKey;
    accountName = userAccountName;
    baseURL = nodeEndpoint;
    mockEnabled = enableMockTransactions;
    if (privateKey != null && privateKey!.isNotEmpty) {
      client = EOSClient(baseURL!, 'v1', privateKeys: [privateKey!, cpuPrivateKey]);
    }
  }

  Transaction buildFreeTransaction(List<Action> actions) {
    var freeAuth = <Authorization>[
      Authorization()
        ..actor = 'harvst.seeds'
        ..permission = 'payforcpu',
      Authorization()
        ..actor = accountName
        ..permission = 'active'
    ];

    var freeAction = Action()
      ..account = 'harvst.seeds'
      ..name = 'payforcpu'
      ..authorization = freeAuth
      ..data = {'account': accountName};

    var transaction = Transaction()
      ..actions = [
        freeAction,
        ...actions,
      ];

    return transaction;
  }

  Future<dynamic> updateProfile({
    String? nickname,
    String? image,
    String? story,
    String? roles,
    String? skills,
    String? interests,
  }) async {
    print('[eos] update profile');

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

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
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> plantSeeds({double? amount}) async {
    print('[eos] plant seeds ($amount)');

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

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
          'quantity': '${amount!.toStringAsFixed(4)} SEEDS',
          'memo': '',
        }
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> createInvite({required double quantity, String? inviteHash}) async {
    print('[eos] create invite $inviteHash ($quantity)');

    var sowQuantity = 5;
    var transferQuantity = quantity - sowQuantity;

    if (mockEnabled) {
      return Future.delayed(
        const Duration(seconds: 1),
        () => HttpMockResponse.transactionResult,
      );
    }

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
          'to': 'join.seeds',
          'quantity': '${quantity.toStringAsFixed(4)} SEEDS',
          'memo': '',
        },
      Action()
        ..account = 'join.seeds'
        ..name = 'invite'
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = 'active'
        ]
        ..data = {
          'sponsor': accountName,
          'transfer_quantity': '${transferQuantity.toStringAsFixed(4)} SEEDS',
          'sow_quantity': '${sowQuantity.toStringAsFixed(4)} SEEDS',
          'invite_hash': inviteHash,
        }
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> acceptInvite({String? accountName, String? publicKey, String? inviteSecret, String? nickname}) async {
    print('[eos] accept invite');

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    var applicationPrivateKey = Config.onboardingPrivateKey;
    var applicationAccount = Config.onboardingAccountName;

    var appClient = EOSClient(baseURL!, 'v1', privateKeys: [applicationPrivateKey]);

    Map data = {
      'account': accountName,
      'publicKey': publicKey,
      'invite_secret': inviteSecret,
      'fullname': nickname,
    };

    var auth = <Authorization>[
      Authorization()
        ..actor = applicationAccount
        ..permission = 'application'
    ];

    var actions = <Action>[
      Action()
        ..account = 'join.seeds'
        ..name = 'acceptnew'
        ..authorization = auth
        ..data = data,
    ];

    var transaction = Transaction()..actions = actions;

    return appClient.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> transferTelos({String? beneficiary, double? amount, memo}) async {
    print('[eos] transfer telos to $beneficiary ($amount) memo: $memo');

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    var transaction = buildFreeTransaction([
      Action()
        ..account = 'eosio.token'
        ..name = 'transfer'
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = 'active'
        ]
        ..data = {
          'from': accountName,
          'to': beneficiary,
          'quantity': '${amount!.toStringAsFixed(4)} TLOS',
          'memo': memo,
        }
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> transferSeeds({String? beneficiary, double? amount, String? memo}) async {
    print('[eos] transfer seeds to $beneficiary ($amount) memo: $memo');

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

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
          'to': beneficiary,
          'quantity': '${amount!.toStringAsFixed(4)} SEEDS',
          'memo': memo,
        }
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> voteProposal({int? id, int? amount}) async {
    print('[eos] vote proposal $id ($amount)');

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    var transaction = buildFreeTransaction([
      Action()
        ..account = 'funds.seeds'
        ..name = amount!.isNegative ? 'against' : 'favour'
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = 'active'
        ]
        ..data = {'user': accountName, 'id': id, 'amount': amount.abs()}
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

// method to properly convert RequiredAuth to JSON - the library doesn't work
  Map<String, dynamic> requiredAuthToJson(RequiredAuth instance) => <String, dynamic>{
        'threshold': instance.threshold,
        'keys': List<dynamic>.from(instance.keys!.map((e) => e.toJson())),
        'accounts': instance.accounts,
        'waits': instance.waits
      };

  Future<dynamic> updatePermission(Permission permission) async {
    print('[eos] update permission ${permission.permName}');

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    var permissionsMap = requiredAuthToJson(permission.requiredAuth!);

    print('converted JSPN: ${permissionsMap.toString()}');

    var transaction = buildFreeTransaction([
      Action()
        ..account = 'eosio'
        ..name = 'updateauth'
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = 'owner'
        ]
        ..data = {
          'account': accountName,
          'permission': permission.permName,
          'parent': permission.parent,
          'auth': permissionsMap
        }
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<List<Permission>> getAccountPermissions() async {
    print('[http] get account permissions');

    if (mockEnabled) {
      return Future.value(HttpMockResponse.accountPermissions);
    }

    final url = Uri.parse('$baseURL/v1/chain/get_account');
    final body = '{ "account_name": "$accountName" }';
    var headers = <String, String>{'Content-type': 'application/json'};

    var res = await post(url, headers: headers, body: body);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      var permissions = List<Permission>.from(body['permissions'].map((item) => Permission.fromJson(item)).toList());

      return permissions;
    } else {
      print('Cannot fetch account permissions...');
      return <Permission>[];
    }
  }

  /// Step 1 in the guardian set up - call this to allow the guard.seeds contract to
  /// change the key.
  ///
  /// Before the guardian contract can act on a recovery request, the users account needs to
  /// allow the guardian contract to change the keys.
  ///
  Future<dynamic> setGuardianPermission() async {
    final currentPermissions = await getAccountPermissions();

    final ownerPermission = currentPermissions.firstWhere((item) => item.permName == 'owner');

    for (Map<String, dynamic>? acct in ownerPermission.requiredAuth!.accounts as Iterable<Map<String, dynamic>?>) {
      if (acct!['permission']['actor'] == 'guard.seeds') {
        print('permission already set, doing nothing');
        return;
      }
    }

    ownerPermission.requiredAuth!.accounts!.add({
      'weight': ownerPermission.requiredAuth!.threshold,
      'permission': {'actor': 'guard.seeds', 'permission': 'eosio.code'}
    });

    return await updatePermission(ownerPermission);
  }

  /// Remove guardian contract permission
  ///
  /// Call this to remove the permission to change keys from guard.seeds contract.
  ///
  /// Call when user turns off recovery to leave the account clean.
  ///
  Future<void> removeGuardianPermission() async {
    final currentPermissions = await getAccountPermissions();

    final ownerPermission = currentPermissions.firstWhere((item) => item.permName == 'owner');

    var newAccounts = <dynamic>[];
    for (Map<String, dynamic>? acct in ownerPermission.requiredAuth!.accounts as Iterable<Map<String, dynamic>?>) {
      if (acct!['permission']['actor'] == 'guard.seeds') {
        //print("found guardian permission");
      } else {
        newAccounts.add(acct);
      }
    }
    ownerPermission.requiredAuth!.accounts = newAccounts;
    await updatePermission(ownerPermission);
  }

  /// Step 2 setting up guardians - set the guardians for an account
  ///
  /// guardians - list of Seeds account names that are the guardians - 3, 4, or 5 elements.
  ///
  /// Will fail when it's already set up - in that case, call cancelGuardians first.
  ///
  Future<dynamic> initGuardians(List<String?> guardians) async {
    print('[eos] init guardians: ' + guardians.toString());

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    var transaction = buildFreeTransaction([
      Action()
        ..account = 'guard.seeds'
        ..name = 'init'
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = 'active'
        ]
        ..data = {
          'user_account': accountName,
          'guardian_accounts': guardians,
          'time_delay_sec': const Duration(days: 1).inSeconds,
        }
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

  /// Recover an account via the key guardian system
  ///
  /// userAcount - the account to recovery, iE current user is a guardian for userAccount
  /// publicKey - the new public key on the account once the recovery is complete
  ///
  /// When 2 or 3 of the guardians call this function, the account can be recovered with claim
  ///
  Future<dynamic> recoverAccount(String? userAccount, String publicKey) async {
    print('[eos] recover account $userAccount');

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    var transaction = buildFreeTransaction([
      Action()
        ..account = 'guard.seeds'
        ..name = 'recover'
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = 'owner'
        ]
        ..data = {
          'guardian_account': accountName,
          'user_account': userAccount,
          'new_public_key': publicKey,
        }
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

  /// Cancel guardians.
  ///
  /// This cancels any recovery currently in process, and removes all guardians
  ///
  Future<dynamic> cancelGuardians() async {
    print('[eos] cancel recovery $accountName');

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    var transaction = buildFreeTransaction([
      Action()
        ..account = 'guard.seeds'
        ..name = 'cancel'
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = 'owner'
        ]
        ..data = {'user_account': accountName}
    ]);

    return await client.pushTransaction(transaction, broadcast: true);
  }

  /// Cancel guardians.
  ///
  /// Safe fallthrough - does not fail when user doesn't have guardians.
  ///
  /// This cancels any recovery currently in process, and removes all guardians
  ///
  Future<dynamic> cancelGuardiansSafe() async {
    try {
      return await cancelGuardians();
    } catch (error) {
      if (error.toString().contains('does not have guards')) {
        return;
      } else {
        rethrow;
      }
    }
  }

  /// Claim recovered account for user - this switches the new public key live at the end of the
  /// recovery process.
  ///
  /// This can be called without logging in - the assumption is that the user lost their key,
  /// asked for recovery, was recovered, waited 24 hours for the time lock - and then calls this
  /// method to regain access.
  ///
  Future<dynamic> claimRecoveredAccount(String userAccount) async {
    print('[eos] claim recovered account $userAccount');

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    var applicationPrivateKey = Config.onboardingPrivateKey;

    var appClient = EOSClient(baseURL!, 'v1', privateKeys: [applicationPrivateKey]);

    var transaction = Transaction()
      ..actions = [
        Action()
          ..account = 'guard.seeds'
          ..name = 'claim'
          ..authorization = [
            Authorization()
              ..actor = 'guard.seeds'
              ..permission = 'application'
          ]
          ..data = {'user_account': userAccount}
      ];

    return appClient.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> cancelRecovery() async {
    print('[eos] cancel recovery $accountName');

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    var transaction = buildFreeTransaction([
      Action()
        ..account = 'guard.seeds'
        ..name = 'cancel'
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = 'active'
        ]
        ..data = {'user_account': accountName}
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> sendTransaction(List<Action>? actions) async {
    print('[eos] send transaction');

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    actions!.forEach((action) => {
          action.authorization = [
            Authorization()
              ..actor = accountName
              ..permission = 'active'
          ]
        });

    var transaction = buildFreeTransaction(actions);

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<String> generateInvoice(double amount) async {
    var auth = [esr.ESRConstants.PlaceholderAuth];

    var data = {
      'from': esr.ESRConstants.PlaceholderName,
      'to': accountName,
      'quantity': '${amount.toStringAsFixed(4)} SEEDS',
      'memo': ''
    };

    var action = esr.Action()
      ..account = 'token.seeds'
      ..name = 'transfer'
      ..authorization = auth
      ..data = data;

    var args = esr.SigningRequestCreateArguments(action: action, chainId: chain_id);

    var request = await esr.SigningRequestManager.create(args,
        options: esr.defaultSigningRequestEncodingOptions(
          nodeUrl: remoteConfigurations.hyphaEndPoint,
        ));

    return request.encode();
  }

  Future<String> generateRecoveryRequest(String accountName, String publicKey) async {
    var auth = [esr.ESRConstants.PlaceholderAuth];

    var data = {
      'guardian_account': esr.ESRConstants.PlaceholderName,
      'user_account': accountName,
      'new_public_key': publicKey,
    };

    var action = esr.Action()
      ..account = 'guard.seeds'
      ..name = 'recover'
      ..authorization = auth
      ..data = data;

    var args = esr.SigningRequestCreateArguments(action: action, chainId: chain_id);

    var request = await esr.SigningRequestManager.create(args,
        options: esr.defaultSigningRequestEncodingOptions(nodeUrl: remoteConfigurations.hyphaEndPoint));

    return request.encode();
  }
}
