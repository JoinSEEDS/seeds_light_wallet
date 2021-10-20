import 'package:async/async.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:eosdart/eosdart.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/domain-shared/app_constants.dart';

abstract class EosRepository {
  String cpuPrivateKey = '5Hy2cvMbrusscGnusLWqYuXyM8fZ65G7DTzs4nDXyiV5wo77n9a';
  String onboardingPrivateKey = '5JhM4vypLzLdDtHo67TR5RtmsYm2mr8F2ugqcrCzfrMPLvo8cQW';
  String onboardingAccountName = 'join.seeds';
  int guardianRecoveryTimeDelaySec = const Duration(hours: 24).inSeconds;

  String? get host => remoteConfigurations.activeEOSServerUrl.url;

  // Actions
  String actionNameAgainst = 'against';
  String actionNameCancel = 'cancel';
  String actionNameFavour = 'favour';
  String actionNameInit = 'init';
  String actionNameClaim = 'claim';
  String actionNameInvite = 'invite';
  String actionNameTransfer = 'transfer';
  String actionNameUpdateauth = 'updateauth';
  String actionNameUpdate = 'update';
  String actionNameMakeresident = 'makeresident';
  String actionNameCanresident = 'canresident';
  String actionNameMakecitizen = 'makecitizen';
  String actionNameCakecitizen = 'cancitizen';
  String actionNameAcceptnew = 'acceptnew';
  String actionNameRecover = 'recover';
  String actionNameUnplant = 'unplant';
  String proposalActionNameDelegate = 'delegate';
  String proposalActionNameUndelegate = 'undelegate';

  // Authorizations
  String permissionActive = 'active';
  String permissionOwner = 'owner';
  String permissionApplication = 'application';

  // Voice scopes
  List<String> voiceScopes = [
    "alliance",
    "funds.seeds", // Note: this is the campaign voice scope
    "milestone",
    // "referendum", // referendum delegation not working on the contract side at the moment
  ];

  Transaction buildFreeTransaction(List<Action> actions, String? accountName) {
    if (testnetMode) {
      return Transaction()..actions = actions;
    }

    final freeAuth = <Authorization>[
      Authorization()
        ..actor = accountHarvest
        ..permission = 'payforcpu',
      Authorization()
        ..actor = accountName
        ..permission = permissionActive
    ];

    final freeAction = Action()
      ..account = accountHarvest
      ..name = 'payforcpu'
      ..authorization = freeAuth
      ..data = {'account': accountName};

    final transaction = Transaction()
      ..actions = [
        freeAction,
        ...actions,
      ];

    return transaction;
  }

  EOSClient buildEosClient() => EOSClient(remoteConfigurations.activeEOSServerUrl.url!, 'v1',
      privateKeys: [settingsStorage.privateKey ?? onboardingPrivateKey, cpuPrivateKey]);

  Result mapEosResponse(dynamic response, Function modelMapper) {
    print('mapEosResponse - transaction id: ${response['transaction_id']}');
    if (response['transaction_id'] != null) {
      print('Model Class: $modelMapper');
      final map = Map<String, dynamic>.from(response);
      return ValueResult(modelMapper(map));
    } else {
      print('ErrorResult: response[transaction_id] is null');
      return ErrorResult(EosError(response['processed']['error_code']));
    }
  }

  Result mapEosError(dynamic error) {
    print('mapEosError: $error');
    return ErrorResult(error);
  }
}

class EosError extends Error {
  int? errorCode;

  EosError(this.errorCode);
}
