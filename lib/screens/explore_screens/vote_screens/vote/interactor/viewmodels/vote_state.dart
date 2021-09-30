import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/interactor/viewmodels/current_remaining_time.dart';

/// --- STATE
class VoteState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final int remainingTimeStamp;
  final CurrentRemainingTime? currentRemainingTime;
  final bool shouldShowDelegateIcon;

  const VoteState({
    required this.pageState,
    this.errorMessage,
    required this.remainingTimeStamp,
    this.currentRemainingTime,
    required this.shouldShowDelegateIcon,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        remainingTimeStamp,
        currentRemainingTime,
        shouldShowDelegateIcon,
      ];

  VoteState copyWith({
    PageState? pageState,
    String? errorMessage,
    int? remainingTimeStamp,
    CurrentRemainingTime? currentRemainingTime,
    bool? shouldShowDelegateIcon,
  }) {
    return VoteState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      remainingTimeStamp: remainingTimeStamp ?? this.remainingTimeStamp,
      currentRemainingTime: currentRemainingTime ?? this.currentRemainingTime,
      shouldShowDelegateIcon: shouldShowDelegateIcon ?? this.shouldShowDelegateIcon,
    );
  }

  factory VoteState.initial(bool featureFlagDelegateEnabled) {
    return VoteState(
        pageState: PageState.initial, remainingTimeStamp: 0, shouldShowDelegateIcon: featureFlagDelegateEnabled);
  }
}
