import 'package:async/async.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:eosdart/eosdart.dart';
import 'package:seeds/constants/config.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/v2/domain-shared/app_constants.dart';

abstract class EosRepository {
  String cpuPrivateKey = Config.cpuPrivateKey;

  // Actions
  String action_name_cancel = 'cancel';
  String action_name_init = 'init';
  String action_name_invite = 'invite';
  String action_name_transfer = 'transfer';
  String action_name_updateauth = 'updateauth';
  String action_name_update = 'update';

  // Authorizations
  String permission_active = 'active';
  String permission_owner = 'owner';

  Transaction buildFreeTransaction(List<Action> actions, String? accountName) {
    var freeAuth = <Authorization>[
      Authorization()
        ..actor = account_harvest
        ..permission = 'payforcpu',
      Authorization()
        ..actor = accountName
        ..permission = permission_active
    ];

    var freeAction = Action()
      ..account = account_harvest
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

  EOSClient buildEosClient() => EOSClient(remoteConfigurations.activeEOSServerUrl.url!, 'v1',
      privateKeys: [settingsStorage.privateKey!, cpuPrivateKey]);

  Result mapEosResponse(dynamic response, Function modelMapper) {
    print('mapEosResponse - transaction id: ${response['transaction_id']}');
    if (response['transaction_id'] != null) {
      print('Model Class: $modelMapper');
      var map = Map<String, dynamic>.from(response);
      return ValueResult(modelMapper(map));
    } else {
      print('ErrorResult: response[transaction_id] is null');
      return ErrorResult(EosError(response['processed']['error_code']));
    }
  }

  Result mapEosError(error) {
    print('mapEosError: ' + error.toString());
    return ErrorResult(error);
  }
}

class EosError extends Error {
  int? errorCode;

  EosError(this.errorCode);
}
