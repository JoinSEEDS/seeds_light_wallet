import 'package:async/async.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_database_guardians_repository.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';

class SendGuardianInviteUseCase {
  final FirebaseDatabaseGuardiansRepository _guardiansRepository = FirebaseDatabaseGuardiansRepository();

  Future<Result> run(Set<MemberModel> usersToInvite) {
    return _guardiansRepository.inviteGuardians(usersToInvite);
  }
}
