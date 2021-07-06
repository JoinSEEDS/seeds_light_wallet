import 'package:async/async.dart';
import 'package:seeds/v2/datasource/remote/api/proposals_repository.dart';

class GetNextMoonPhaseUseCase {
  Future<Result> run() => ProposalsRepository().getMoonPhases();
}
