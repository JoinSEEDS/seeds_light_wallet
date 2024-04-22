import 'dart:async';
import 'package:async/async.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:seeds/crypto/eosdart/eosdart.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_scopes.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';

abstract class EosRepository {
  late final String cpuPrivateKey = dotenv.env['PAYCPU_SEEDS_KEY'] ?? '';

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

  //TODO(CH): generalize this to (1) don't fail on non-SEEDS-members, (2) support
  //  alternative cpu payers
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
      final map = Map<String, dynamic>.from(response as Map<String, dynamic>);
      return ValueResult<T>(modelMapper(map) as T);
    } else {
      print('ErrorResult: $response');
      return ErrorResult(EosError(response['processed']['error_code'] as int?));
    }
  }

  ErrorResult mapEosError(dynamic error) {
    final regex = RegExp(r'^.*Internal Service Error.*assertion failure with message: ([^\"]*)');
    print('mapEosError: $error');
    final match = regex.firstMatch(error as String);
    if (match != null && match.groupCount == 1) {
      return ErrorResult("Transaction error:\n${match.group(1)!}");
    }
    return ErrorResult(error);
  }
}

class EosError extends Error {
  int? errorCode;

  EosError(this.errorCode);
}
