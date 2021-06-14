import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/vote/interactor/viewmodels/current_remaining_time.dart';

/// --- STATE
class VoteState extends Equatable {
  final PageState pageState;
  final int remainingTimeStamp;
  final CurrentRemainingTime? currentRemainingTime;
  final String? errorMessage;

  const VoteState({
    required this.pageState,
    required this.remainingTimeStamp,
    this.currentRemainingTime,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        pageState,
        remainingTimeStamp,
        currentRemainingTime,
        errorMessage,
      ];

  VoteState copyWith({
    PageState? pageState,
    int? remainingTimeStamp,
    CurrentRemainingTime? currentRemainingTime,
    String? errorMessage,
  }) {
    return VoteState(
      pageState: pageState ?? this.pageState,
      remainingTimeStamp: remainingTimeStamp ?? this.remainingTimeStamp,
      currentRemainingTime: currentRemainingTime ?? this.currentRemainingTime,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory VoteState.initial() {
    return const VoteState(pageState: PageState.initial, remainingTimeStamp: 0);
  }
}
