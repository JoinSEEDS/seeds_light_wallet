import 'package:async/async.dart';
import 'package:seeds/v2/datasource/remote/api/explore_repository.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

class GetExploreUseCase {
  final ExploreRepository _exploreRepository = ExploreRepository();

  Future<Result> run(String accountName) {
    return _exploreRepository.getExplorePageData(accountName);
  }
}
