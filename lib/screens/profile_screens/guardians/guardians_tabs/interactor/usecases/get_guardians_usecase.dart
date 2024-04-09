import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/members_repository.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_guardians_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';

class GetGuardiansUseCase {
  final FirebaseDatabaseGuardiansRepository _repository = FirebaseDatabaseGuardiansRepository();
  final MembersRepository _membersRepository = MembersRepository();

  Stream<List<GuardianModel>> getGuardians() {
    return _repository
        .getGuardiansForUser(settingsStorage.accountName)
        .asyncMap((List<GuardianModel> event) => getMemberData(event));
  }

  Future<List<GuardianModel>> getMemberData(List<GuardianModel> guardians) async {
    final Iterable<Future<Result>> futures =
        guardians.map((GuardianModel e) => _membersRepository.getMemberByAccountName(e.uid));
    final List<Result> results = await Future.wait(futures);
    final Iterable<Result<dynamic>> filtered = results.where((Result element) => element.isValue);

    return guardians.map((GuardianModel guardian) => mapGuardian(guardian, filtered)).toList();
  }

  GuardianModel mapGuardian(GuardianModel guardian, Iterable<Result<dynamic>> filtered) {
    final ProfileModel match =
        filtered.firstWhere((element) => element.asValue!.value.account == guardian.uid).asValue!.value as ProfileModel;

    return guardian.copyWith(image: match.image, nickname: match.nickname);
  }
}
