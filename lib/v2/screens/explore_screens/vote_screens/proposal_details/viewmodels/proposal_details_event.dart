import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class ProposalDetailsEvent extends Equatable {
  const ProposalDetailsEvent();
  @override
  List<Object> get props => [];
}

class OnFavourButtonTapped extends ProposalDetailsEvent {
  const OnFavourButtonTapped();
  @override
  String toString() => 'OnFavourButtonTapped';
}

class OnAbstainButtonTapped extends ProposalDetailsEvent {
  const OnAbstainButtonTapped();
  @override
  String toString() => 'OnAbstainButtonTapped';
}

class OnAgainstButtonTapped extends ProposalDetailsEvent {
  const OnAgainstButtonTapped();
  @override
  String toString() => 'OnAgainstButtonTapped';
}

class OnConfirmButtonPressed extends ProposalDetailsEvent {
  const OnConfirmButtonPressed();
  @override
  String toString() => 'OnConfirmButtonPressed';
}

class OnNextProposalTapped extends ProposalDetailsEvent {
  const OnNextProposalTapped();
  @override
  String toString() => 'OnNextProposalTapped';
}
