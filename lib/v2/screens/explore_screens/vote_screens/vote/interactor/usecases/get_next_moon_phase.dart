import 'package:seeds/v2/datasource/remote/api/proposals_repository.dart';

export 'package:async/src/result/result.dart';

class GetNextMoonPhaseUseCase {
  Future<Result> run() => ProposalsRepository().getMoonPhases();
}
