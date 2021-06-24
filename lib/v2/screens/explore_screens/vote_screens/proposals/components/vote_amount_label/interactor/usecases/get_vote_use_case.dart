import 'package:seeds/v2/datasource/remote/api/proposals_repository.dart';

export 'package:async/src/result/result.dart';

class GetVoteUseCase {
  Future<Result> run(int proposalId, String account) {
    return ProposalsRepository().getVote(proposalId, account);
  }
}
