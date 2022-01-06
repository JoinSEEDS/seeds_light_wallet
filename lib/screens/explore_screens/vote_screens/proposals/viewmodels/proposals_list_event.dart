part of '../viewmodels/proposals_list_bloc.dart';

abstract class ProposalsListEvent extends Equatable {
  const ProposalsListEvent();
  @override
  List<Object?> get props => [];
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

class OnProposalCardTapped extends ProposalsListEvent {
  final int index;

  const OnProposalCardTapped(this.index);

  @override
  String toString() => 'OnProposalCardTapped { proposal index: $index }';
}

class ClearProposalsListPageCommand extends ProposalsListEvent {
  const ClearProposalsListPageCommand();

  @override
  String toString() => 'ClearProposalsListPageCommand';
}
