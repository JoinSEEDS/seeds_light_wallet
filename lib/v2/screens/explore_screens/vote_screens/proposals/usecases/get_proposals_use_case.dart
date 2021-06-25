import 'package:seeds/v2/datasource/remote/api/proposals_repository.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/vote/interactor/viewmodels/proposal_type_model.dart';

export 'package:async/src/result/result.dart';

const String _alliance = 'alliance';
const String _campaign = 'campaign';
const String _milestone = 'milestone';

class GetProposalsUseCase {
  final ProposalsRepository _proposalsRepository = ProposalsRepository();

  Future<List<Result>> run(ProposalType proposalType) {
    var futures = [
      _proposalsRepository.getProposals(proposalType),
      _proposalsRepository.getSupportLevels(_alliance),
      _proposalsRepository.getSupportLevels(_campaign),
      _proposalsRepository.getSupportLevels(_milestone),
    ];
    return Future.wait(futures);
  }
}
