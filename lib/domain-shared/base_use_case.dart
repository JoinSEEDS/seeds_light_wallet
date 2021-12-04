import 'package:async/async.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

abstract class _BaseUseCase<T> {
  bool areAllResultsError(List<Result> results) {
    return results.where((Result element) => element.isValue).isEmpty;
  }

  bool areAllResultsSuccess(List<Result> results) {
    return results.where((Result element) => element.isError).isEmpty;
  }
}

abstract class InputUseCase<T, I> extends _BaseUseCase {
  Future<Result<T>> run(I input);
}

abstract class NoInputUseCase<T> extends _BaseUseCase<T> {
  Future<Result<T>> run();
}

extension ValueResult<T> on Result<T> {
  T? get valueOrNull => isValue ? asValue!.value : null;
}
