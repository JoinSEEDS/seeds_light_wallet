import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class ProposalsEvent extends Equatable {
  const ProposalsEvent();
  @override
  List<Object?> get props => [];
}

class InitialLoadProposals extends ProposalsEvent {
  const InitialLoadProposals();
  @override
  String toString() => 'InitialLoadProposals';
}

class LoadProposalsByScroll extends ProposalsEvent {
  const LoadProposalsByScroll();
  @override
  String toString() => 'LoadProposalsByScroll';
}
