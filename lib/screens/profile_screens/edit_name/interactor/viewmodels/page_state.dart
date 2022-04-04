import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_state.freezed.dart';

@freezed
class Union<T> with _$Union<T> {
  const factory Union(T value) = Data<T>;

  const factory Union.loading() = Loading<T>;

  const factory Union.error([String? message]) = ErrorDetails<T>;
}
