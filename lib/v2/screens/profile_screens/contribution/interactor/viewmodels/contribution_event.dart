import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class ContributionEvent extends Equatable {
  const ContributionEvent();
  @override
  List<Object> get props => [];
}

class LoadScores extends ContributionEvent {
  const LoadScores();
  @override
  String toString() => 'LoadScores';
}
