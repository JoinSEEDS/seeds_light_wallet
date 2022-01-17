part of 'vote_amount_label_bloc.dart';

abstract class VoteAmountLabelEvent extends Equatable {
  const VoteAmountLabelEvent();

  @override
  List<Object?> get props => [];
}

class LoadVoteAmount extends VoteAmountLabelEvent {
  final ProposalViewModel proposal;

  const LoadVoteAmount(this.proposal);

  @override
  String toString() => 'LoadVoteAmount { proposal $proposal }';
}
