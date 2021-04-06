import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class ExploreEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadExplore extends ExploreEvent {
  final String userName;

  LoadExplore({@required this.userName}) : assert(userName != null);

  @override
  String toString() => 'LoadExplore: { userName: $userName }';
}
