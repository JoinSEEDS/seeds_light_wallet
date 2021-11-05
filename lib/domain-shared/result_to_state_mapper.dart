import 'package:async/async.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

class StateMapper {
  bool areAllResultsError(List<Result> results) {
    return results.where((Result element) => element.isValue).isEmpty;
  }

  bool areAllResultsSuccess(List<Result> results) {
    return results.where((Result element) => element.isError).isEmpty;
  }
}

extension ValueResult<T> on Result<T> {
  T? get valueOrNull => isValue ? asValue!.value : null;
}
