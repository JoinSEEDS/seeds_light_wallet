import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class ProposalDetailsEvent extends Equatable {
  const ProposalDetailsEvent();
  @override
  List<Object> get props => [];
}

class OnLoadProposalData extends ProposalDetailsEvent {
  const OnLoadProposalData();
  @override
  String toString() => 'OnLoadProposalData';
}

class OnVoteAmountChanged extends ProposalDetailsEvent {
  final int voteAmount;

  const OnVoteAmountChanged(this.voteAmount);

  @override
  String toString() => 'OnVoteAmountChanged';
}

class OnVoteButtonPressed extends ProposalDetailsEvent {
  const OnVoteButtonPressed();
  @override
  String toString() => 'OnVoteButtonPressed';
}

class OnConfirmVoteButtonPressed extends ProposalDetailsEvent {
  const OnConfirmVoteButtonPressed();
  @override
  String toString() => 'OnConfirmVoteButtonPressed';
}

class OnNextProposalTapped extends ProposalDetailsEvent {
  const OnNextProposalTapped();
  @override
  String toString() => 'OnNextProposalTapped';
}
