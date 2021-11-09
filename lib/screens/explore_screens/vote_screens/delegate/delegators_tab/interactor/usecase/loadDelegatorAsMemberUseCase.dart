import 'package:seeds/datasource/remote/api/members_repository.dart';
import 'package:seeds/datasource/remote/model/delegate_model.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';

class LoadDelegatorAsMemberUseCase {
  final MembersRepository _membersRepository = MembersRepository();

  Future<Result> run({required List <DelegateModel> delegators}) {



    return _membersRepository.getMemberByAccountName('delegateAccount');
  }
}
