import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/score_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class ContributionState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final ScoreModel? score;

  const ContributionState({required this.pageState, this.errorMessage, this.score});

  @override
  List<Object?> get props => [pageState, errorMessage, score];

  ContributionState copyWith({PageState? pageState, String? errorMessage, ScoreModel? score}) {
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
