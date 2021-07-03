import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class ExploreEvent extends Equatable {
  const ExploreEvent();
  @override
  List<Object> get props => [];
}

class LoadExploreData extends ExploreEvent {
  const LoadExploreData();
  @override
  String toString() => 'LoadExploreData';
}
