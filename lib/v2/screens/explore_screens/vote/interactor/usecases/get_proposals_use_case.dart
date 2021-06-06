import 'package:async/async.dart';
import 'package:seeds/v2/datasource/remote/api/votes_repository.dart';

class GetProposalsUseCase {
  Future<Result> run() => VotesRepository().getProposals();
}
