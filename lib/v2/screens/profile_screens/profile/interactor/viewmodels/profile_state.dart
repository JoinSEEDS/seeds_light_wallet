import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/datasource/remote/model/score_model.dart';

class ProfileState extends Equatable {
  final PageState pageState;
  final ProfileModel? profile;
  final ScoreModel? score;
  final String? errorMessage;

  const ProfileState({
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

  ProfileState copyWith({
    PageState? pageState,
    ProfileModel? profile,
    ScoreModel? score,
    String? errorMessage,
  }) {
    return ProfileState(
      pageState: pageState ?? this.pageState,
      profile: profile ?? this.profile,
      score: score ?? this.score,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ProfileState.initial() {
    return const ProfileState(pageState: PageState.initial);
  }
}
