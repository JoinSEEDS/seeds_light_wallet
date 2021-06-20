import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/guardians_repository.dart';
import 'package:seeds/v2/datasource/remote/api/members_repository.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:eosdart_ecc/eosdart_ecc.dart';

class FetchRecoverGuardianInitialDataUseCase {
  final GuardiansRepository _guardiansRepository = GuardiansRepository();
  final MembersRepository _membersRepository = MembersRepository();

  Future<RecoverGuardianInitialDTO> run(List<String> guardians) async {
    //Result link = await _guardiansRepository.getAccountRecovery(settingsStorage.accountName);

    print("FetchRecoverGuardianInitialDataUseCase accountName pKey");
    String accountName = settingsStorage.accountName;
    String pKey = settingsStorage.privateKey!;

    String publicKey = EOSPrivateKey.fromString(pKey).toEOSPublicKey().toString();
    print("oublic $publicKey");

    Result link = await _guardiansRepository.generateRecoveryRequest(accountName, publicKey);
    List<Result> membersData = await _getMembersData(guardians);
    return RecoverGuardianInitialDTO(link, membersData);
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

  RecoverGuardianInitialDTO(this.link, this.membersData);
}
