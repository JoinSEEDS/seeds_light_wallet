import 'package:async/async.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

abstract class BaseUseCase<T> {
  bool areAllResultsError(List<Result> results) {
    return results.where((Result element) => element.isValue).isEmpty;
  }

  bool areAllResultsSuccess(List<Result> results) {
    return results.where((Result element) => element.isError).isEmpty;
  }
}

abstract class InputUseCase<T> extends BaseUseCase {
  Future<Result<T>> run(Input input);
}

abstract class NoInputUseCase<T> extends BaseUseCase<T> {
  Future<Result<T>> run();
}

class Input<I> {
  final I input;

  Input(this.input);
}

extension ValueResult<T> on Result<T> {
  T? get valueOrNull => isValue ? asValue!.value : null;
}
