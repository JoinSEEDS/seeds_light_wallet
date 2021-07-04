import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';

export 'package:async/src/result/result.dart';

class GetProposalDetailsDataUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<List<Result>> run(String accountName) {
    var futures = [
      _profileRepository.getProfile(accountName),
    ];
    return Future.wait(futures);
  }
}
