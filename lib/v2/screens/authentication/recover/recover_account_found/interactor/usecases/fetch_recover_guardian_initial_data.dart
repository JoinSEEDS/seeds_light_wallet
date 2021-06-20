// ignore: import_of_legacy_library_into_null_safe
import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/guardians_repository.dart';
import 'package:seeds/v2/datasource/remote/api/members_repository.dart';

export 'package:async/src/result/result.dart';

class FetchRecoverGuardianInitialDataUseCase {
  final GuardiansRepository _guardiansRepository = GuardiansRepository();
  final MembersRepository _membersRepository = MembersRepository();

  Future<RecoverGuardianInitialDTO> run(List<String> guardians) async {
    print("FetchRecoverGuardianInitialDataUseCase accountName pKey");
    String accountName = settingsStorage.accountName;
    // TODO(gguij002): Figure this out.
    // String pKey = settingsStorage.privateKey;
    //
    // String publicKey = EOSPrivateKey.fromString(pKey).toEOSPublicKey().toString();
    // print("public $publicKey");

    Result accountRecovery = await _guardiansRepository.getAccountRecovery(settingsStorage.accountName);
    Result accountGuardians = await _guardiansRepository.getAccountGuardians(accountName);
    Result link =
        ValueResult("TODO: FAKE KEY"); //await _guardiansRepository.generateRecoveryRequest(accountName, publicKey);
    List<Result> membersData = await _getMembersData(guardians);

    return RecoverGuardianInitialDTO(link, membersData, accountRecovery, accountGuardians);
  }

  Future<List<Result>> _getMembersData(List<String> guardians) async {
    Iterable<Future<Result>> futures = guardians.map((String e) => _membersRepository.getMemberByAccountName(e));
    List<Result> results = await Future.wait(futures);
    Iterable<Result<dynamic>> filtered = results.where((Result element) => element.isValue);

    return filtered.toList();
  }
}

class RecoverGuardianInitialDTO {
  final Result link;
  final List<Result> membersData;
  final Result userRecoversModel;
  final Result accountGuardians;

  RecoverGuardianInitialDTO(
    this.link,
    this.membersData,
    this.userRecoversModel,
    this.accountGuardians,
  );
}
