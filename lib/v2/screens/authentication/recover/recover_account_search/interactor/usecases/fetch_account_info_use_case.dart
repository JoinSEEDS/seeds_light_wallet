import 'package:seeds/v2/datasource/remote/api/members_repository.dart';

class FetchAccountInfoUseCase {
  final MembersRepository _memberInfo = MembersRepository();

  Future<Result> run(String accountName) {
    return _memberInfo.getMemberByAccountName(accountName);
  }
}
