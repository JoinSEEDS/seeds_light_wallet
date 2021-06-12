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

class LoadProposalsByScroll extends ProposalsListEvent {
  const LoadProposalsByScroll();
  @override
  String toString() => 'LoadProposalsByScroll';
}

class LoadProposalsByRefresh extends ProposalsListEvent {
  const LoadProposalsByRefresh();
  @override
  String toString() => 'LoadProposalsByRefresh';
}
