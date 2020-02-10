import 'package:eosdart/eosdart.dart';
import 'package:flutter/widgets.dart' show BuildContext;
import 'package:provider/provider.dart';
import 'package:seeds/constants/config.dart';
import 'package:seeds/constants/http_mock_response.dart';

class EosService {
  String privateKey;
  String accountName;
  String baseURL = Config.defaultEndpoint;
  String cpuPrivateKey = Config.cpuPrivateKey;
  EOSClient client;
  bool mockEnabled;

  static EosService of(BuildContext context, {bool listen = true}) =>
      Provider.of(context, listen: listen);

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
    if (privateKey != null) {
      client =
          EOSClient(baseURL, 'v1', privateKeys: [privateKey, cpuPrivateKey]);
    }
  }

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

  Future<dynamic> updateProfile({
    String nickname,
    String image,
    String story,
    String roles,
    String skills,
    String interests,
  }) async {
    print("[eos] update profile");

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    Transaction transaction = buildFreeTransaction([
      Action()
        ..account = "accts.seeds"
        ..name = "update"
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = "active"
        ]
        ..data = {
          "user": accountName,
          "type": "individual",
          "nickname": nickname,
          "image": image,
          "story": story,
          "roles": roles,
          "skills": skills,
          "interests": interests
        }
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> plantSeeds({String amount}) async {
    print("[eos] plant seeds ($amount)");

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    Transaction transaction = buildFreeTransaction([
      Action()
        ..account = "token.seeds"
        ..name = "transfer"
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = "active"
        ]
        ..data = {
          "from": accountName,
          "to": "harvst.seeds",
          "quantity": "$amount SEEDS",
          "memo": "",
        }
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> createInvite(
      {double transferQuantity, double sowQuantity, String inviteHash}) async {
    print("[eos] create invite $inviteHash ($transferQuantity + $sowQuantity)");

    if (mockEnabled) {
      return Future.delayed(
        Duration(seconds: 1),
        () => HttpMockResponse.transactionResult,
      );
    }

    double totalQuantity = sowQuantity + transferQuantity;

    Transaction transaction = buildFreeTransaction([
      Action()
        ..account = "token.seeds"
        ..name = "transfer"
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = "active"
        ]
        ..data = {
          "from": accountName,
          "to": "join.seeds",
          "quantity": "${totalQuantity.toStringAsFixed(4)} SEEDS",
          "memo": "",
        },
      Action()
        ..account = "join.seeds"
        ..name = "invite"
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = "active"
        ]
        ..data = {
          "sponsor": accountName,
          "transfer_quantity": "${transferQuantity.toStringAsFixed(4)} SEEDS",
          "sow_quantity": "${sowQuantity.toStringAsFixed(4)} SEEDS",
          "invite_hash": inviteHash,
        }
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> acceptInvite(
      {String accountName, String publicKey, String inviteSecret}) async {
    print("[eos] accept invite");

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    String applicationPrivateKey = Config.onboardingPrivateKey;
    String applicationAccount = Config.onboardingAccountName;

    EOSClient appClient =
        EOSClient(baseURL, 'v1', privateKeys: [applicationPrivateKey]);

    Map data = {
      "account": accountName,
      "publicKey": publicKey,
      "invite_secret": inviteSecret,
    };

    print(inviteSecret);

    List<Authorization> auth = [
      Authorization()
        ..actor = applicationAccount
        ..permission = "application"
    ];

    List<Action> actions = [
      Action()
        ..account = 'join.seeds'
        ..name = 'acceptnew'
        ..authorization = auth
        ..data = data
    ];

    Transaction transaction = Transaction()..actions = actions;

    return appClient.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> transferTelos({String beneficiary, double amount}) async {
    print("[eos] transfer telos to $beneficiary ($amount)");

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    Transaction transaction = buildFreeTransaction([
      Action()
        ..account = "eosio.token"
        ..name = "transfer"
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = "active"
        ]
        ..data = {
          "from": accountName,
          "to": beneficiary,
          "quantity": "${amount.toStringAsFixed(4)} TLOS",
          "memo": "",
        }
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> transferSeeds({String beneficiary, double amount}) async {
    print("[eos] transfer seeds to $beneficiary ($amount)");

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    Transaction transaction = buildFreeTransaction([
      Action()
        ..account = "token.seeds"
        ..name = "transfer"
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = "active"
        ]
        ..data = {
          "from": accountName,
          "to": beneficiary,
          "quantity": "${amount.toStringAsFixed(4)} SEEDS",
          "memo": "",
        }
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> voteProposal({int id, int amount}) async {
    print("[eos] vote proposal $id ($amount)");

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    Transaction transaction = buildFreeTransaction([
      Action()
        ..account = "funds.seeds"
        ..name = amount.isNegative ? "against" : "favour"
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = "active"
        ]
        ..data = {"voter": accountName, "id": id, "amount": amount.abs()}
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }
}
