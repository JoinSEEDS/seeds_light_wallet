import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class ProposalDetailsEvent extends Equatable {
  const ProposalDetailsEvent();
  @override
  List<Object> get props => [];
}

class OnNextProposalTapped extends ProposalDetailsEvent {
  const OnNextProposalTapped();
  @override
  String toString() => 'OnNextProposalTapped';
}

class OnPreviousProposalTapped extends ProposalDetailsEvent {
  const OnPreviousProposalTapped();
  @override
  String toString() => 'OnPreviousProposalTapped';
}
