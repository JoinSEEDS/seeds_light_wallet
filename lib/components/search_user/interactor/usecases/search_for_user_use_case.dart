import 'package:async/async.dart';
import 'package:seeds/datasource/remote/api/members_repository.dart';

class SearchForMemberUseCase {
  Future<List<Result>> run(String searchQuery) {
    final futures = [
      MembersRepository().getMembersWithFilter(searchQuery),
      MembersRepository().getTelosAccounts(searchQuery),
    ];
    return Future.wait(futures);
  }
}
