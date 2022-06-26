import 'dart:async';
import 'package:async/async.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:seeds/crypto/eosdart/eosdart.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_scopes.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';

abstract class EosRepository {
  String cpuPrivateKey = '5Hy2cvMbrusscGnusLWqYuXyM8fZ65G7DTzs4nDXyiV5wo77n9a';
  String onboardingPrivateKey = '5JhM4vypLzLdDtHo67TR5RtmsYm2mr8F2ugqcrCzfrMPLvo8cQW';
  String onboardingAccountName = 'join.seeds';
  int guardianRecoveryTimeDelaySec = const Duration(hours: 24).inSeconds;

  String? get host => remoteConfigurations.activeEOSServerUrl.url;

  // Authorizations
  String permissionActive = 'active';
  String permissionOwner = 'owner';
  String permissionApplication = 'application';
  String permissionPayForCpu = 'payforcpu';

  List<String> voiceScopes = [
    SeedsCode.voiceScopeAlliance.value,
    SeedsCode.voiceScopeCampaign.value,
    SeedsCode.voiceScopeMilestone.value,
    // "referendum", // referendum delegation not working on the contract side at the moment
  ];

  Transaction buildFreeTransaction(List<Action> actions, String? accountName) {
    if (testnetMode) {
      return Transaction()..actions = actions;
    }

    final freeAuth = <Authorization>[
      Authorization()
        ..actor = SeedsCode.accountHarvest.value
        ..permission = permissionPayForCpu,
      Authorization()
        ..actor = accountName
        ..permission = permissionActive
    ];

    final freeAction = Action()
      ..account = SeedsCode.accountHarvest.value
      ..name = permissionPayForCpu
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

  FutureOr<Result<T>> mapEosResponse<T>(dynamic response, Function modelMapper) {
    print('mapEosResponse - transaction id: ${response['transaction_id']}');
    if (response['transaction_id'] != null) {
      print('Model Class: $modelMapper');
      final map = Map<String, dynamic>.from(response);
      return ValueResult(modelMapper(map));
    } else {
      print('ErrorResult: $response');
      return ErrorResult(EosError(response['processed']['error_code']));
    }
  }

  ErrorResult mapEosError(dynamic error) {
    if (kDebugMode) {
      print('mapEosError: $error');
    }
    FirebaseCrashlytics.instance.log('mapEosError: $error');
    return ErrorResult(error);
  }
}

class EosError extends Error {
  int? errorCode;

  EosError(this.errorCode);
}
