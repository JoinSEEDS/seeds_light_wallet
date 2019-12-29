import 'package:eosdart/eosdart.dart';
import 'package:seeds/screens/onboarding/helpers.dart';
import 'package:seeds/services/auth_service.dart';

class EosService {
  final AuthService authService = AuthService();

  final String endpointApi = "https://api.telos.eosindex.io";

  Future<dynamic> createInvite({ String inviterAccount, String transferQuantity, String sowQuantity, String inviteHash }) async {
    String privateKey = await authService.getPrivateKey();
    String inviterAccount = await authService.getAccountName();

    EOSClient client = EOSClient(endpointApi, 'v1', privateKeys: [privateKey]);

    Map data = {
      "sponsor": inviterAccount,
      "transfer_quantity": transferQuantity,
      "sow_quantity": sowQuantity,
      "invite_hash": inviteHash,
    };

    List<Authorization> auth = [
      Authorization()
        ..actor = inviterAccount
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

  Future<dynamic> acceptInvite(String accountName, String publicKey, String inviteSecret) async {
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