import 'package:async/async.dart';
import 'package:seeds/v2/datasource/remote/api/balance_repository.dart';
import 'package:seeds/v2/datasource/remote/api/members_repository.dart';
import 'package:seeds/v2/datasource/remote/api/planted_repository.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';
import 'package:seeds/v2/datasource/remote/api/voice_repository.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

class SearchForMemberUseCase {

  Future<Result> run(String searchQuery) {
    return  MembersRepository().getMembersWithFilter(searchQuery);
  }
}
