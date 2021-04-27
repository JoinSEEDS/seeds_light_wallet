import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/datasource/remote/model/score_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class CitizenshipState extends Equatable {
  final PageState pageState;
  final ProfileModel? profile;
  final ScoreModel? score;
  final String? errorMessage;

  const CitizenshipState({
    required this.pageState,
    this.profile,
    this.score,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        pageState,
        profile,
        score,
        errorMessage,
      ];

  CitizenshipState copyWith({
    PageState? pageState,
    ProfileModel? profile,
    ScoreModel? score,
    String? errorMessage,
  }) {
    return CitizenshipState(
      pageState: pageState ?? this.pageState,
      profile: profile ?? this.profile,
      score: score ?? this.score,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory CitizenshipState.initial() {
    return const CitizenshipState(pageState: PageState.initial);
  }
}
