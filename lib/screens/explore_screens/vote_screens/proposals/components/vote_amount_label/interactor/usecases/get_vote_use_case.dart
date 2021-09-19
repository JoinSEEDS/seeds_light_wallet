import 'package:async/async.dart';
import 'package:seeds/datasource/local/cache_repository.dart';
import 'package:seeds/datasource/remote/api/proposals_repository.dart';
import 'package:seeds/datasource/remote/model/vote_model.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/viewmodels/proposal_view_model.dart';

class GetVoteUseCase {
  final ProposalsRepository _proposalsRepository = ProposalsRepository();

  Future<Result> run(ProposalViewModel proposal, String account) async {
    late Result result;
    VoteModel? voteModel;
    if (proposal.proposalCategory == ProposalCategory.referendum) {
      result = await _proposalsRepository.getReferendumVote(proposal.id, account);
      if (result.isValue) {
        voteModel = result.asValue!.value as VoteModel;
      }
    } else {
      final cacheRepository = const CacheRepository();
      voteModel = await cacheRepository.getProposalVote(account, proposal.id);
      if (voteModel == null) {
        result = await _proposalsRepository.getProposalVote(proposal.id, account);
        if (result.isValue) {
          voteModel = result.asValue!.value as VoteModel;
          if (voteModel.isVoted) {
            await cacheRepository.saveProposalVote(proposal.id, voteModel);
          }
        }
      }
    }
    return result;
  }
}
