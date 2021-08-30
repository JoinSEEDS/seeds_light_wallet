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
    print("FetchRecoverGuardianInitialDataUseCase accountName pKey");
    final String recoveryPrivateKey;
    if (settingsStorage.privateKey != null && settingsStorage.inRecoveryMode) {
      recoveryPrivateKey = settingsStorage.privateKey!;
    } else {
      recoveryPrivateKey = EOSPrivateKey.fromRandom().toString();
      settingsStorage.enableRecoveryMode(accountName: accountName, privateKey: recoveryPrivateKey);
    }

    final String publicKey = EOSPrivateKey.fromString(recoveryPrivateKey).toEOSPublicKey().toString();
    print("public $publicKey");

    final Result accountRecovery = await _guardiansRepository.getAccountRecovery(accountName);
    final Result accountGuardians = await _guardiansRepository.getAccountGuardians(accountName);
    Result link = await _guardiansRepository.generateRecoveryRequest(accountName, publicKey);

    // Check
    link = await generateFirebaseDynamicLink(link);

    List<Result> membersData = [];
    if (accountGuardians.isValue) {
      final UserGuardiansModel guardians = accountGuardians.asValue!.value;
      membersData = await _getMembersData(guardians.guardians);
    }

    return RecoverGuardianInitialDTO(link, membersData, accountRecovery, accountGuardians, recoveryPrivateKey);
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
      final guardianLink = await _createFirebaseDynamicLinkUseCase.createDynamicLink(guardian_target_link, linkValue);
      return guardianLink;
    } else {
      return link;
    }
  }
}

class RecoverGuardianInitialDTO {
  final Result link;
  final List<Result> membersData;
  final Result userRecoversModel;
  final Result accountGuardians;
  final String privateKey;

  RecoverGuardianInitialDTO(
    this.link,
    this.membersData,
    this.userRecoversModel,
    this.accountGuardians,
    this.privateKey,
  );
}
