import 'package:async/async.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:seeds/v2/datasource/remote/api/guardians_repository.dart';
import 'package:seeds/v2/datasource/remote/api/members_repository.dart';
import 'package:seeds/v2/domain-shared/app_constants.dart';
import 'package:seeds/v2/domain-shared/shared_use_cases/cerate_firebase_dynamic_link_use_case.dart';

class FetchRecoverGuardianInitialDataUseCase {
  final GuardiansRepository _guardiansRepository = GuardiansRepository();
  final MembersRepository _membersRepository = MembersRepository();
  final CreateFirebaseDynamicLinkUseCase _createFirebaseDynamicLinkUseCase = CreateFirebaseDynamicLinkUseCase();

  Future<RecoverGuardianInitialDTO> run(List<String> guardians, String accountName) async {
    print("FetchRecoverGuardianInitialDataUseCase accountName pKey");
    final recoveryPrivateKey = EOSPrivateKey.fromRandom().toString();

    String publicKey = EOSPrivateKey.fromString(recoveryPrivateKey).toEOSPublicKey().toString();
    print("public $publicKey");

    Result accountRecovery = await _guardiansRepository.getAccountRecovery(accountName);
    Result accountGuardians = await _guardiansRepository.getAccountGuardians(accountName);
    Result link = await _guardiansRepository.generateRecoveryRequest(accountName, publicKey);

    // Check
    link = await generateFirebaseDynamicLink(link);

    List<Result> membersData = await _getMembersData(guardians);

    return RecoverGuardianInitialDTO(link, membersData, accountRecovery, accountGuardians, recoveryPrivateKey);
  }

  Future<List<Result>> _getMembersData(List<String> guardians) async {
    Iterable<Future<Result>> futures = guardians.map((String e) => _membersRepository.getMemberByAccountName(e));
    List<Result> results = await Future.wait(futures);
    Iterable<Result<dynamic>> filtered = results.where((Result element) => element.isValue);

    return filtered.toList();
  }

  Future<Result<dynamic>> generateFirebaseDynamicLink(Result<dynamic> link) async {
    if (link.isValue) {
      String linkValue = link.asValue!.value;
      var guardianLink = await _createFirebaseDynamicLinkUseCase.createDynamicLink(guardian_target_link, linkValue);
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
