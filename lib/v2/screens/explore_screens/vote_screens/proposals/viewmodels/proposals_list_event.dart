import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class ProposalsListEvent {
  const ProposalsListEvent();
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
