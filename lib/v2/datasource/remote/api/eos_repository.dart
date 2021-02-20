import 'package:eosdart/eosdart.dart';
import 'package:seeds/constants/config.dart';

abstract class EosRepository {
  String privateKey;
  String accountName;
  String baseURL = Config.defaultEndpoint;
  String cpuPrivateKey = Config.cpuPrivateKey;
  EOSClient client;

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
}
