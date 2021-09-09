import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';
import 'package:seeds/datasource/remote/api/proposals_repository.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/interactor/viewmodels/proposal_type_model.dart';

const String _alliance = 'alliance';
const String _campaign = 'campaign';
const String _milestone = 'milestone';

class GetProposalsDataUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();
  final ProposalsRepository _proposalsRepository = ProposalsRepository();

  Future<List<Result>> run(ProposalType proposalType) {
    final futures = [
      _profileRepository.getProfile(settingsStorage.accountName),
      _proposalsRepository.getProposals(proposalType),
      _proposalsRepository.getReferendums(proposalType),
      _proposalsRepository.getSupportLevel(_alliance),
      _proposalsRepository.getSupportLevel(_campaign),
      _proposalsRepository.getSupportLevel(_milestone),
      _proposalsRepository.getQuorumLevel('quorum.high'),
    ];
    return Future.wait(futures);
  }
}
