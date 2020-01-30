import 'package:eosdart/eosdart.dart';
import 'package:seeds/constants/config.dart';
import 'package:seeds/constants/http_mock_response.dart';

class EosService {
  String privateKey;
  String accountName;
  String baseURL = Config.defaultEndpoint;
  bool mockEnabled;

  void update(
      {userPrivateKey,
      userAccountName,
      nodeEndpoint,
      bool enableMockTransactions = false}) {
    privateKey = userPrivateKey;
    accountName = userAccountName;
    baseURL = nodeEndpoint;
    mockEnabled = enableMockTransactions;
  }

  List<Action> buildFreeTransaction(List<Action> actions) {
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

    return [
      freeAction,
      ...actions,
    ];
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

    EOSClient client = EOSClient(baseURL, 'v1', privateKeys: [privateKey]);

    Map data = {
      "sponsor": accountName,
      "transfer_quantity": "${transferQuantity.toStringAsFixed(4)} SEEDS",
      "sow_quantity": "${sowQuantity.toStringAsFixed(4)} SEEDS",
      "invite_hash": inviteHash,
    };

    List<Authorization> auth = [
      Authorization()
        ..actor = accountName
        ..permission = "active"
    ];

    List<Action> actions = buildFreeTransaction([
      Action()
        ..account = "join.seeds"
        ..name = "invite"
        ..authorization = auth
        ..data = data
    ]);

    Transaction transaction = Transaction()..actions = actions;

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

    EOSClient client =
        EOSClient(baseURL, 'v1', privateKeys: [applicationPrivateKey]);

    Map data = {
      "account": accountName,
      "publicKey": publicKey,
      "invite_secret": inviteSecret,
    };

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

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> transferTelos({String beneficiary, double amount}) async {
    print("[eos] transfer telos to $beneficiary ($amount)");

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    EOSClient client = EOSClient(baseURL, 'v1', privateKeys: [privateKey]);

    Map data = {
      "from": accountName,
      "to": beneficiary,
      "quantity": "${amount.toStringAsFixed(4)} TLOS",
      "memo": "",
    };

    List<Authorization> auth = [
      Authorization()
        ..actor = accountName
        ..permission = "active"
    ];

    List<Action> actions = buildFreeTransaction([
      Action()
        ..account = "eosio.token"
        ..name = "transfer"
        ..authorization = auth
        ..data = data
    ]);

    Transaction transaction = Transaction()..actions = actions;

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> transferSeeds({String beneficiary, double amount}) async {
    print("[eos] transfer seeds to $beneficiary ($amount)");

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    EOSClient client = EOSClient(baseURL, 'v1', privateKeys: [privateKey]);

    Map data = {
      "from": accountName,
      "to": beneficiary,
      "quantity": "${amount.toStringAsFixed(4)} SEEDS",
      "memo": "",
    };

    List<Authorization> auth = [
      Authorization()
        ..actor = accountName
        ..permission = "active"
    ];

    List<Action> actions = buildFreeTransaction([
      Action()
        ..account = "token.seeds"
        ..name = "transfer"
        ..authorization = auth
        ..data = data
    ]);

    Transaction transaction = Transaction()..actions = actions;

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> voteProposal({int id, int amount}) async {
    print("[eos] vote proposal $id ($amount)");

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    EOSClient client = EOSClient(baseURL, 'v1', privateKeys: [privateKey]);

    Map data = {"voter": accountName, "id": id, "amount": amount.abs()};

    List<Authorization> auth = [
      Authorization()
        ..actor = accountName
        ..permission = "active"
    ];

    List<Action> actions = buildFreeTransaction([
      Action()
        ..account = "funds.seeds"
        ..name = amount.isNegative ? "against" : "favour"
        ..authorization = auth
        ..data = data
    ]);

    Transaction transaction = Transaction()..actions = actions;

    return client.pushTransaction(transaction, broadcast: true);
  }
}
