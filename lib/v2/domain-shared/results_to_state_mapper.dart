import 'package:async/async.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

abstract class ResultsToStateMapper<State> {
  State mapResultsToState(State state, List<Result> results);
  bool areAllResultsError(List<Result> results) {
    return results.where((Result element) => element.isValue).isEmpty;
  }
}
