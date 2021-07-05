import 'package:async/async.dart';
import 'package:seeds/v2/datasource/remote/api/members_repository.dart';

class SearchForMemberUseCase {
  Future<Result> run(String searchQuery) {
    return MembersRepository().getMembersWithFilter(searchQuery);
  }
}
