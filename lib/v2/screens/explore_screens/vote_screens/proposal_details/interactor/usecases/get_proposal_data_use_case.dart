import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';
import 'package:seeds/v2/datasource/remote/api/proposals_repository.dart';

class GetProposalDataUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();
  final ProposalsRepository _proposalsRepository = ProposalsRepository();

  Future<List<Result>> run({required String creatorAccount, required int proposalId}) {
    var futures = [
      _profileRepository.getProfile(creatorAccount),
      _proposalsRepository.getVote(proposalId, settingsStorage.accountName),
      // one more call comming here next PRs
    ];
    return Future.wait(futures);
  }
}
