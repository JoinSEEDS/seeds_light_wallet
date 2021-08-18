import 'package:async/async.dart';
import 'package:seeds/datasource/remote/api/proposals_repository.dart';

class GetNextMoonPhaseUseCase {
  Future<Result> run() => ProposalsRepository().getMoonPhases();
}
