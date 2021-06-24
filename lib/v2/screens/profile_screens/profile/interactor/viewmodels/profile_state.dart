import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/datasource/remote/model/score_model.dart';

class ShowLogoutDialog extends PageCommand {}

/// --- STATE
class ProfileState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final ProfileModel? profile;
  final ScoreModel? score;
  final PageCommand? showLogoutDialog;
  final bool showLogoutButton;
  final bool hasSecurityNotification;

  const ProfileState({
    required this.pageState,
    this.errorMessage,
    this.profile,
    this.score,
    this.showLogoutDialog,
    required this.showLogoutButton,
    required this.hasSecurityNotification,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        profile,
        score,
        showLogoutDialog,
        showLogoutButton,
        hasSecurityNotification,
      ];

  ProfileState copyWith({
    PageState? pageState,
    String? errorMessage,
    ProfileModel? profile,
    ScoreModel? score,
    PageCommand? showDialog,
    bool? showLogoutButton,
    bool? hasSecurityNotification,
  }) {
    return ProfileState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      profile: profile ?? this.profile,
      score: score ?? this.score,
      showLogoutDialog: showDialog,
      showLogoutButton: showLogoutButton ?? this.showLogoutButton,
      hasSecurityNotification: hasSecurityNotification ?? this.hasSecurityNotification,
    );
  }

  factory ProfileState.initial() {
    return const ProfileState(pageState: PageState.initial, showLogoutButton: false, hasSecurityNotification: false);
  }
}
