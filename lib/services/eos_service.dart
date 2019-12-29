import 'package:eosdart/eosdart.dart';
import 'package:seeds/screens/onboarding/helpers.dart';
import 'package:seeds/services/auth_service.dart';

class EosService {
  final AuthService authService = AuthService();

  Future<dynamic> createAccount(String accountName, String publicKey, String inviteSecret) async {
    String endpointApi = "https://api.telos.eosindex.io";

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

    String endpointApi = "https://api.telos.eosindex.io";

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

}