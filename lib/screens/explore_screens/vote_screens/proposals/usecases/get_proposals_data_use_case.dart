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
    late final List<Future<Result>> futures;
    if (proposalType.referendumStage.length > 1) {
      // For History section referendums need 2 request for passed and failed
      futures = [
        _profileRepository.getProfile(settingsStorage.accountName),
        _proposalsRepository.getProposals(proposalType),
        _proposalsRepository.getReferendums(proposalType.referendumStage.first, proposalType.isReverse),
        _proposalsRepository.getReferendums(proposalType.referendumStage.last, proposalType.isReverse),
        _proposalsRepository.getSupportLevel(_alliance),
        _proposalsRepository.getSupportLevel(_campaign),
        _proposalsRepository.getSupportLevel(_milestone),
      ];
    } else {
      futures = [
        _profileRepository.getProfile(settingsStorage.accountName),
        _proposalsRepository.getProposals(proposalType),
        _proposalsRepository.getReferendums(proposalType.referendumStage.first, proposalType.isReverse),
        _proposalsRepository.getSupportLevel(_alliance),
        _proposalsRepository.getSupportLevel(_campaign),
        _proposalsRepository.getSupportLevel(_milestone),
      ];
    }
    return Future.wait(futures);
  }
}
