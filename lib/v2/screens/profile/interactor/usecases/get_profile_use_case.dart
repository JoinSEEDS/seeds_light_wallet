import 'package:async/async.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';

export 'package:async/src/result/result.dart';

class GetProfileUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<Result> run(String accountName) {
    return _profileRepository.getProfile(accountName);
  }
}
