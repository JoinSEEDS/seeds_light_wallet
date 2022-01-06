part of 'vote_bloc.dart';

abstract class VoteEvent extends Equatable {
  const VoteEvent();
  @override
  List<Object?> get props => [];
}

class OnFetchInitialVoteSectionData extends VoteEvent {
  @override
  String toString() => 'OnFetchInitialVoteSectionData';
}

class Tick extends VoteEvent {
  final int timer;

  const Tick(this.timer);

  @override
  List<Object?> get props => [timer];

  @override
  String toString() => 'Tick { remaining seconds: $timer }';
}

class OnRefreshCurrentDelegates extends VoteEvent {
  const OnRefreshCurrentDelegates();

  @override
  String toString() => 'OnRefreshCurrentDelegates';
}
