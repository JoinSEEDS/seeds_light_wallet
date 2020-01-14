import 'package:eosdart/eosdart.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/services/config_service.dart';

class EosService {
  AuthNotifier _auth;
  ConfigService _config;

  final String endpointApi = "https://api.telos.eosindex.io";

  void init({ AuthNotifier auth, ConfigService config }) {
    print("eos update dependencies...");
    if (_auth == null) {
      _auth = auth;
    }
    if (_config == null) {
      _config = config;
    }
  }

  Future<dynamic> createAccount(
      String accountName, String publicKey, String inviteSecret
  ) async {
    String applicationPrivateKey = _config.value("APPLICATION_PRIVATE_KEY");
    String applicationAccount = _config.value("APPLICATION_ACCOUNT_NAME");

    EOSClient client =
        EOSClient(endpointApi, 'v1', privateKeys: [ applicationPrivateKey ]);

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

  Future<dynamic> transferSeeds(String accountName, String amount) async {
    String privateKey = _auth.privateKey;
    String from = _auth.accountName;

    EOSClient client = EOSClient(endpointApi, 'v1', privateKeys: [privateKey]);

    Map data = {
      "from": from,
      "to": accountName,
      "quantity": "$amount SEEDS",
      "memo": "",
    };

    List<Authorization> auth = [
      Authorization()
        ..actor = from
        ..permission = "active"
    ];

    List<Action> actions = [
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
    String privateKey = _auth.privateKey;
    String from = _auth.accountName;

    EOSClient client = EOSClient(endpointApi, 'v1', privateKeys: [privateKey]);

    Map data = {"voter": from, "id": id, "amount": amount.abs()};

    List<Authorization> auth = [
      Authorization()
        ..actor = from
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
