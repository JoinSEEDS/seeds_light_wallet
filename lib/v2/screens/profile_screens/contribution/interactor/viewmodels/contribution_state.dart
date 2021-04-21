import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/score_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class ContributionState extends Equatable {
  final PageState pageState;
  final ScoreModel? score;
  final String? errorMessage;

  const ContributionState({
    required this.pageState,
    this.score,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        pageState,
        score,
        errorMessage,
      ];

  ContributionState copyWith({
    PageState? pageState,
    ScoreModel? score,
    String? errorMessage,
  }) {
    return ContributionState(
      pageState: pageState ?? this.pageState,
      score: score ?? this.score,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ContributionState.initial() {
    return const ContributionState(pageState: PageState.initial);
  }
}
