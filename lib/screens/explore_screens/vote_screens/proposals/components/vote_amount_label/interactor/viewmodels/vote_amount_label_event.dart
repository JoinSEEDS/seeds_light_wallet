import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class VoteAmountLabelEvent extends Equatable {
  const VoteAmountLabelEvent();
  @override
  List<Object> get props => [];
}

class LoadVoteAmount extends VoteAmountLabelEvent {
  final int proposalId;
  const LoadVoteAmount(this.proposalId);
  @override
  String toString() => 'LoadVoteAmount { proposalId $proposalId }';
}
