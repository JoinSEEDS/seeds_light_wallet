import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/viewmodels/proposal_view_model.dart';

/// --- EVENTS
@immutable
abstract class VoteAmountLabelEvent extends Equatable {
  const VoteAmountLabelEvent();
  @override
  List<Object> get props => [];
}

class LoadVoteAmount extends VoteAmountLabelEvent {
  final ProposalViewModel proposal;
  const LoadVoteAmount(this.proposal);
  @override
  String toString() => 'LoadVoteAmount { proposal $proposal }';
}
