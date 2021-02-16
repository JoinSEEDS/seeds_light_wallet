import 'package:async/async.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

abstract class StateMapper<T, State> {
  State mapResultToState(State state, Result<T> result);
}
