part of 'vote_bloc.dart';

class VoteState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final int remainingTimeStamp;
  final CurrentRemainingTime? currentRemainingTime;
  final bool shouldShowDelegateIcon;
  final bool isCitizen;
  final List<CategoryDelegate> currentDelegates;

  const VoteState({
    required this.pageState,
    this.errorMessage,
    required this.remainingTimeStamp,
    this.currentRemainingTime,
    required this.shouldShowDelegateIcon,
    required this.isCitizen,
    required this.currentDelegates,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        remainingTimeStamp,
        currentRemainingTime,
        shouldShowDelegateIcon,
        isCitizen,
        currentDelegates,
      ];

  VoteState copyWith({
    PageState? pageState,
    String? errorMessage,
    int? remainingTimeStamp,
    CurrentRemainingTime? currentRemainingTime,
    bool? shouldShowDelegateIcon,
    bool? isCitizen,
    List<CategoryDelegate>? currentDelegates,
  }) {
    return VoteState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      remainingTimeStamp: remainingTimeStamp ?? this.remainingTimeStamp,
      currentRemainingTime: currentRemainingTime ?? this.currentRemainingTime,
      shouldShowDelegateIcon: shouldShowDelegateIcon ?? this.shouldShowDelegateIcon,
      isCitizen: isCitizen ?? this.isCitizen,
      currentDelegates: currentDelegates ?? this.currentDelegates,
    );
  }

  factory VoteState.initial(bool featureFlagDelegateEnabled, bool isCitizen) {
    return VoteState(
      pageState: PageState.initial,
      remainingTimeStamp: 0,
      shouldShowDelegateIcon: featureFlagDelegateEnabled,
      isCitizen: isCitizen,
      currentDelegates: [],
    );
  }
}
