import 'package:async/async.dart';
import 'package:seeds/datasource/remote/api/members_repository.dart';

class LoadMemberDataUseCase {
  Future<Result> run(String account) {
    return MembersRepository().getMemberByAccountName(account);
  }
}
