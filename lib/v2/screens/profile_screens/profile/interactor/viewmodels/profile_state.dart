import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/datasource/remote/model/score_model.dart';

class ShowLogoutDialog extends PageCommand {}

/// --- STATE
class ProfileState extends Equatable {
  final PageState pageState;
  final ProfileModel? profile;
  final ScoreModel? score;
  final PageCommand? showLogoutDialog;
  final bool showLogoutButton;
  final String? errorMessage;

  const ProfileState({
    required this.pageState,
    this.profile,
    this.score,
    this.showLogoutDialog,
    required this.showLogoutButton,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        pageState,
        profile,
        score,
        showLogoutDialog,
        showLogoutButton,
        errorMessage,
      ];

  ProfileState copyWith({
    PageState? pageState,
    ProfileModel? profile,
    ScoreModel? score,
    PageCommand? showDialog,
    bool? showLogoutButton,
    String? errorMessage,
  }) {
    return ProfileState(
      pageState: pageState ?? this.pageState,
      profile: profile ?? this.profile,
      score: score ?? this.score,
      showLogoutDialog: showDialog,
      showLogoutButton: showLogoutButton ?? this.showLogoutButton,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ProfileState.initial() {
    return const ProfileState(pageState: PageState.initial, showLogoutButton: false);
  }
}
