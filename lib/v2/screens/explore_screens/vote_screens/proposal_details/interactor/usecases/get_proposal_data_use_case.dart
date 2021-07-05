import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';

export 'package:async/src/result/result.dart';

class GetProposalDataUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<List<Result>> run(String accountName) {
    var futures = [
      _profileRepository.getProfile(accountName),
      // more calls comming here next PRs
    ];
    return Future.wait(futures);
  }
}
