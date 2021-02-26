import 'package:async/async.dart';
import 'package:eosdart/eosdart.dart';
import 'package:seeds/constants/config.dart';

abstract class EosRepository {
  String cpuPrivateKey = Config.cpuPrivateKey;

  Transaction buildFreeTransaction(List<Action> actions, String accountName) {
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

  EOSClient buildEosClient(String nodeEndpoint, String privateKey) =>
      EOSClient(nodeEndpoint, 'v1', privateKeys: [privateKey, cpuPrivateKey]);

  Result mapEosSuccess(dynamic response, Function modelMapper) {
    print('mapSuccess - transaction id: ${response['transaction_id']}');
    if (response['transaction_id'] != null) {
      print('Model Class: $modelMapper');
      var map = Map<String, dynamic>.from(response);
      return ValueResult(modelMapper(map));
    } else {
      return ErrorResult(EosError(response['processed']['error_code']));
    }
  }

  Result mapEosError(error) {
    print('mapError: ' + error.toString());
    return ErrorResult(error);
  }
}

class EosError extends Error {
  int errorCode;

  EosError(this.errorCode);
}
