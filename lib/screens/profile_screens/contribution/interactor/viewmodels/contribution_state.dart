import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/profile_screens/contribution/interactor/viewmodels/scores_view_model.dart';

class ContributionState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final ScoresViewModel? score;

  const ContributionState({required this.pageState, this.errorMessage, this.score});

  @override
  List<Object?> get props => [pageState, errorMessage, score];

  ContributionState copyWith({PageState? pageState, String? errorMessage, ScoresViewModel? score}) {
    return ContributionState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      score: score ?? this.score,
    );
  }

  factory ContributionState.initial() {
    return const ContributionState(pageState: PageState.initial);
  }
}
