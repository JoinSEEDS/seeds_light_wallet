import 'package:async/async.dart';
import 'package:seeds/v2/datasource/remote/api/proposals_repository.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/vote/interactor/viewmodels/proposal_type_model.dart';

class GetProposalsUseCase {
  final ProposalsRepository _proposalsRepository = ProposalsRepository();

  Future<List<Result>> run(ProposalType proposalType) {
    var futures = [
      _proposalsRepository.getProposals(proposalType),
      _proposalsRepository.getSupportLevels('alliance'),
      _proposalsRepository.getSupportLevels('campaign'),
      _proposalsRepository.getSupportLevels('milestone'),
    ];
    return Future.wait(futures);
  }
}
