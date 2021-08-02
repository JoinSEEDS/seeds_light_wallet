import 'package:async/async.dart';
import 'package:hive/hive.dart';
import 'package:seeds/v2/datasource/local/cache_repository.dart';
import 'package:seeds/v2/datasource/remote/api/proposals_repository.dart';
import 'package:seeds/v2/datasource/remote/model/vote_model.dart';

class GetVoteUseCase {
  Future<Result> run(int proposalId, String account) async {
    var box = await Hive.openBox<VoteModel>("votes.1.box");
    var cache = CacheRepository<VoteModel>(box);
    VoteModel? voteModel = cache.get(proposalId);
    if (voteModel == null) {
      var result = await ProposalsRepository().getVote(proposalId, account);
      if (result.isValue) {
        voteModel = result.asValue!.value as VoteModel;
        if (voteModel.isVoted) {
          await cache.add(proposalId, voteModel);
        }
      }
    }
    return ValueResult(voteModel);
  }
}
