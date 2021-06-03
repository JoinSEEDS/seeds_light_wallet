import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class VoteEvent extends Equatable {
  const VoteEvent();
  @override
  List<Object?> get props => [];
}

class LoadProposals extends VoteEvent {
  const LoadProposals();
  @override
  String toString() => 'LoadProposals';
}

class OnTabChange extends VoteEvent {
  final int tabIndex;
  const OnTabChange(this.tabIndex);
  @override
  String toString() => 'OnTabChnage { tabIndex: $tabIndex }';
}
