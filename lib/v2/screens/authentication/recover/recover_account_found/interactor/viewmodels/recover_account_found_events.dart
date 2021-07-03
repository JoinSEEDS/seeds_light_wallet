import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class RecoverAccountFoundEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchInitialData extends RecoverAccountFoundEvent {
  @override
  String toString() => 'FetchInitialData';
}
