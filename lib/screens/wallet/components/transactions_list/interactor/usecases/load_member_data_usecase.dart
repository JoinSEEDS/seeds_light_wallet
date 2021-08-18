import 'package:seeds/datasource/remote/api/members_repository.dart';
import 'package:async/async.dart';

class LoadMemberDataUseCase {
  Future<Result> run(String account) {
    return MembersRepository().getMemberByAccountName(account);
  }
}
