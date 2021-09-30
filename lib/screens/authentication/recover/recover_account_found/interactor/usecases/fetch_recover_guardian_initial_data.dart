import 'package:async/async.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/guardians_repository.dart';
import 'package:seeds/datasource/remote/api/members_repository.dart';
import 'package:seeds/datasource/remote/model/account_guardians_model.dart';
import 'package:seeds/domain-shared/app_constants.dart';
import 'package:seeds/domain-shared/shared_use_cases/cerate_firebase_dynamic_link_use_case.dart';

class FetchRecoverGuardianInitialDataUseCase {
  final GuardiansRepository _guardiansRepository = GuardiansRepository();
  final MembersRepository _membersRepository = MembersRepository();
  final CreateFirebaseDynamicLinkUseCase _createFirebaseDynamicLinkUseCase = CreateFirebaseDynamicLinkUseCase();

  Future<RecoverGuardianInitialDTO> run(String accountName) async {
    print("FetchRecoverGuardianInitialDataUseCase $accountName pKey");

    final Result accountRecovery = await _guardiansRepository.getAccountRecovery(accountName);
    final Result accountGuardians = await _guardiansRepository.getAccountGuardians(accountName);

    List<Result> membersData = [];
    if (accountGuardians.isValue) {
      final UserGuardiansModel guardians = accountGuardians.asValue!.value;
      membersData = await _getMembersData(guardians.guardians);
    }

    if (settingsStorage.privateKey != null && settingsStorage.inRecoveryMode) {
      return _continueWithRecovery(accountRecovery, accountGuardians, membersData);
    } else {
      return _startNewRecovery(accountRecovery, accountGuardians, membersData, accountName);
    }
  }

  Future<List<Result>> _getMembersData(List<String> guardians) async {
    final Iterable<Future<Result>> futures = guardians.map((String e) => _membersRepository.getMemberByAccountName(e));
    final List<Result> results = await Future.wait(futures);
    final Iterable<Result<dynamic>> filtered = results.where((Result element) => element.isValue);

    return filtered.toList();
  }

  Future<Result<dynamic>> generateFirebaseDynamicLink(Result<dynamic> link) async {
    if (link.isValue) {
      final String linkValue = link.asValue!.value;
      final guardianLink = await _createFirebaseDynamicLinkUseCase.createDynamicLink(guardianTargetLink, linkValue);
      return guardianLink;
    } else {
      return link;
    }
  }

  /// USER already started a recovery. Fetch the values from storage
  RecoverGuardianInitialDTO _continueWithRecovery(
    Result accountRecovery,
    Result accountGuardians,
    List<Result> membersData,
  ) {
    return RecoverGuardianInitialDTO(
      link: ValueResult(Uri.parse(settingsStorage.recoveryLink)),
      membersData: membersData,
      userRecoversModel: accountRecovery,
      accountGuardians: accountGuardians,
      privateKey: settingsStorage.privateKey!,
    );
  }

  /// USER does not have an active recovery. Create new recovery values.
  Future<RecoverGuardianInitialDTO> _startNewRecovery(
    Result accountRecovery,
    Result accountGuardians,
    List<Result> membersData,
    String accountName,
  ) async {
    final String recoveryPrivateKey = EOSPrivateKey.fromRandom().toString();
    final String publicKey = EOSPrivateKey.fromString(recoveryPrivateKey).toEOSPublicKey().toString();
    print("public $publicKey");

    Result link = await _guardiansRepository.generateRecoveryRequest(accountName, publicKey);

    // Check
    link = await generateFirebaseDynamicLink(link);

    return RecoverGuardianInitialDTO(
        link: link,
        membersData: membersData,
        userRecoversModel: accountRecovery,
        accountGuardians: accountGuardians,
        privateKey: recoveryPrivateKey);
  }
}

class RecoverGuardianInitialDTO {
  final Result link;
  final List<Result> membersData;
  final Result userRecoversModel;
  final Result accountGuardians;
  final String privateKey;

  RecoverGuardianInitialDTO({
    required this.link,
    required this.membersData,
    required this.userRecoversModel,
    required this.accountGuardians,
    required this.privateKey,
  });
}
