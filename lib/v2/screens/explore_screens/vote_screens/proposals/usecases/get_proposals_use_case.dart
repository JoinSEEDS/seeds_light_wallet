import 'package:async/async.dart';
import 'package:seeds/v2/datasource/remote/api/proposals_repository.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/vote/interactor/viewmodels/proposal_type_model.dart';

class GetProposalsUseCase {
  Future<Result> run(ProposalType proposalType) {
    return ProposalsRepository().getProposals(proposalType);
  }
}
