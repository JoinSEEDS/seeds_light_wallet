import 'package:seeds/datasource/remote/api/members_repository.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';

class LoadDelegateAsMemberUseCase {
  final MembersRepository _membersRepository = MembersRepository();

  Future<Result> run({required String delegateAccount}) {
    return _membersRepository.getMemberByAccountName(delegateAccount);
  }
}
