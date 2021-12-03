import 'package:async/async.dart';
import 'package:seeds/datasource/remote/api/members_repository.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';

class SearchForMemberUseCase {
  Future<List<Result<List<MemberModel>>>> run(String searchQuery) {
    final futures = [
      MembersRepository().getMembersWithFilter(searchQuery),
      MembersRepository().getTelosAccounts(searchQuery),
      MembersRepository().getFullNameSearchMembers(searchQuery),
    ];
    return Future.wait(futures);
  }
}
