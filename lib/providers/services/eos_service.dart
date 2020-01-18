import 'package:eosdart/eosdart.dart';
import 'package:seeds/constants/config.dart';

class EosService {
  String privateKey;
  String accountName;

  void init({ userPrivateKey, userAccountName }) {
    privateKey = userPrivateKey;
    accountName = userAccountName;
  }

  Future<dynamic> createInvite({ String transferQuantity, String sowQuantity, String inviteHash }) async {
    EOSClient client = EOSClient(Config.defaultEndpoint, 'v1', privateKeys: [privateKey]);

    Map data = {
      "sponsor": accountName,
      "transfer_quantity": transferQuantity,
      "sow_quantity": sowQuantity,
      "invite_hash": inviteHash,
    };

    List<Authorization> auth = [
      Authorization()
        ..actor = accountName
        ..permission = "active"
    ];

    List<Action> actions = [
      Action()
        ..account = "join.seeds"
        ..name = "invite"
        ..authorization = auth
        ..data = data
    ];

    Transaction transaction = Transaction()..actions = actions;

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> acceptInvite(
      String accountName, String publicKey, String inviteSecret
  ) async {
    String applicationPrivateKey = Config.onboardingPrivateKey;
    String applicationAccount = Config.onboardingAccountName;

    EOSClient client =
        EOSClient(Config.defaultEndpoint, 'v1', privateKeys: [ applicationPrivateKey ]);

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

  Future<dynamic> transferSeeds(String beneficiary, String amount) async {
    EOSClient client = EOSClient(Config.defaultEndpoint, 'v1', privateKeys: [privateKey, Config.cpuPrivateKey]);

    Map data = {
      "from": accountName,
      "to": beneficiary,
      "quantity": "$amount SEEDS",
      "memo": "",
    };

    List<Authorization> cpuAuth = [
      Authorization()
        ..actor = "harvst.seeds"
        ..permission = "payforcpu",
      Authorization()
        ..actor = accountName
        ..permission = "active"
    ];

    List<Authorization> auth = [
      Authorization()
        ..actor = accountName
        ..permission = "active"
    ];

    List<Action> actions = [
      Action()
        ..account = "harvst.seeds"
        ..name = 'payforcpu'
        ..authorization = cpuAuth
        ..data = { "account": accountName },
      Action()
        ..account = 'token.seeds'
        ..name = 'transfer'
        ..authorization = auth
        ..data = data
    ];

    Transaction transaction = Transaction()..actions = actions;

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> voteProposal({int id, int amount}) async {
    EOSClient client = EOSClient(Config.defaultEndpoint, 'v1', privateKeys: [privateKey]);

    Map data = {"voter": accountName, "id": id, "amount": amount.abs()};

    List<Authorization> auth = [
      Authorization()
        ..actor = accountName
        ..permission = "active"
    ];

    List<Action> actions = [
      Action()
        ..account = "funds.seeds"
        ..name = amount.isNegative ? "against" : "favour"
        ..authorization = auth
        ..data = data
    ];

    Transaction transaction = Transaction()..actions = actions;

    return client.pushTransaction(transaction, broadcast: true);
  }
}
