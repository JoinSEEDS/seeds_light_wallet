import 'package:async/async.dart';
import 'package:seeds/datasource/local/cache_repository.dart';
import 'package:seeds/datasource/remote/api/proposals_repository.dart';
import 'package:seeds/datasource/remote/model/vote_model.dart';

class GetVoteUseCase {
  Future<Result> run(int proposalId, String account) async {
    final cacheRepository = const CacheRepository();
    VoteModel? voteModel = await cacheRepository.getProposalVote(account, proposalId);
    if (voteModel == null) {
      final result = await ProposalsRepository().getVote(proposalId, account);
      if (result.isValue) {
        voteModel = result.asValue!.value as VoteModel;
        if (voteModel.isVoted) {
          await cacheRepository.saveProposalVote(proposalId, voteModel);
        }
      }
    }
    return ValueResult(voteModel);
  }
}
