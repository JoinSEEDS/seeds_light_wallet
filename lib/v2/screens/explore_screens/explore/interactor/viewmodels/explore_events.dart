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

class OnExploreCardTapped extends ExploreEvent {
  final String route;

  const OnExploreCardTapped(this.route);

  @override
  String toString() => 'OnExploreCardTapped { route: $route }';
}

class ClearExplorePageCommand extends ExploreEvent {
  const ClearExplorePageCommand();
  @override
  String toString() => 'ClearExplorePageCommand';
}
