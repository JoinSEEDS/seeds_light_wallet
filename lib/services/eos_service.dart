import 'package:eosdart/eosdart.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/screens/onboarding/helpers.dart';

class EosService {
  AuthNotifier _auth;

  final String endpointApi = "https://api.telos.eosindex.io";

  void init({ AuthNotifier auth }) {
    print("eos update dependencies...");
    if (_auth == null) {
      _auth = auth;
    }
  }

  Future<dynamic> createAccount(
      String accountName, String publicKey, String inviteSecret) async {
    EOSClient client =
        EOSClient(endpointApi, 'v1', privateKeys: [applicationPrivateKey]);

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
