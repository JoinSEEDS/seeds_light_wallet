import 'package:async/async.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

extension ValueResult<T> on Result<T> {
  T? get valueOrNull => asValue?.value;

  /// Maps a result to a value, or Throws if its not a value result
  T get valueOrCrash {
    if (isError) {
      throw Exception("Result is not value");
    } else {
      return asValue!.value;
    }
  }
}
