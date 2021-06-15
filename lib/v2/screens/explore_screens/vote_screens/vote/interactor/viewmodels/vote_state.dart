import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/vote/interactor/viewmodels/current_remaining_time.dart';

/// --- STATE
class VoteState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final int remainingTimeStamp;
  final CurrentRemainingTime? currentRemainingTime;

  const VoteState({
    required this.pageState,
    this.errorMessage,
    required this.remainingTimeStamp,
    this.currentRemainingTime,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        remainingTimeStamp,
        currentRemainingTime,
      ];

  VoteState copyWith({
    PageState? pageState,
    String? errorMessage,
    int? remainingTimeStamp,
    CurrentRemainingTime? currentRemainingTime,
  }) {
    return VoteState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      remainingTimeStamp: remainingTimeStamp ?? this.remainingTimeStamp,
      currentRemainingTime: currentRemainingTime ?? this.currentRemainingTime,
    );
  }

  factory VoteState.initial() {
    return const VoteState(pageState: PageState.initial, remainingTimeStamp: 0);
  }
}
