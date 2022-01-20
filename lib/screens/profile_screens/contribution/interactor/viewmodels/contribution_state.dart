part of 'contribution_bloc.dart';

class ContributionState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final ScoresViewModel? score;
  final PageCommand? pageCommand;

  const ContributionState({
    required this.pageState,
    this.errorMessage,
    this.score,
    this.pageCommand,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        score,
        pageCommand,
      ];

  ContributionState copyWith({
    PageState? pageState,
    String? errorMessage,
    ScoresViewModel? score,
    PageCommand? pageCommand,
  }) {
    return ContributionState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      score: score ?? this.score,
      pageCommand: pageCommand,
    );
  }

  factory ContributionState.initial() {
    return const ContributionState(pageState: PageState.initial);
  }
}
