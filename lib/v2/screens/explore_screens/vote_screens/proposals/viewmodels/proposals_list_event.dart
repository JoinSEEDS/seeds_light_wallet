import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class ProposalsListEvent extends Equatable {
  const ProposalsListEvent();
  @override
  List<Object> get props => [];
}

class InitialLoadProposals extends ProposalsListEvent {
  const InitialLoadProposals();
  @override
  String toString() => 'InitialLoadProposals';
}

class OnUserProposalsScroll extends ProposalsListEvent {
  const OnUserProposalsScroll();
  @override
  String toString() => 'OnUserProposalsScroll';
}

class OnUserProposalsRefresh extends ProposalsListEvent {
  const OnUserProposalsRefresh();
  @override
  String toString() => 'OnUserProposalsRefresh';
}
