import 'package:eosdart/eosdart.dart';
import 'package:seeds/screens/onboarding/helpers.dart';
import 'package:seeds/services/auth_service.dart';

class EosService {
  final AuthService authService = AuthService();

  final String endpointApi = "https://api.telos.eosindex.io";

  Future<dynamic> createAccount(String accountName, String publicKey, String inviteSecret) async {
    EOSClient client = EOSClient(endpointApi, 'v1', privateKeys: [applicationPrivateKey]);

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
    String privateKey = await authService.getPrivateKey();
    String from = await authService.getAccountName();

    EOSClient client =
        EOSClient(endpointApi, 'v1', privateKeys: [privateKey]);

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

  Future<dynamic> voteProposal({ bool favour, int id, int amount }) async {
    String privateKey = await authService.getPrivateKey();
    String from = await authService.getAccountName();

    EOSClient client = EOSClient(endpointApi, 'v1', privateKeys: [privateKey]);

    Map data = {
      "voter": from,
      "id": id,
      "amount": amount
    };

    List<Authorization> auth = [
      Authorization()
        ..actor = from
        ..permission = "active"
    ];

    List<Action> actions = [
      Action()
        ..account = "funds.seeds"
        ..name = favour ? "favour" : "against"
        ..authorization = auth
        ..data = data
    ];

    Transaction transaction = Transaction()..actions = actions;

    return client.pushTransaction(transaction, broadcast: true);
  }
}