import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/screens/profile_screens/contribution/interactor/viewmodels/scores_view_model.dart';

enum CitizenshipUpgradeStatus { notReady, canResident, canCitizen }

/// --- STATE
class ProfileState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final ProfileModel? profile;
  final ScoresViewModel? score;
  final PageCommand? pageCommand;
  final bool showLogoutButton;
  final bool hasSecurityNotification;
  final CitizenshipUpgradeStatus citizenshipUpgradeStatus;

  const ProfileState({
    required this.pageState,
    this.errorMessage,
    this.profile,
    this.score,
    this.pageCommand,
    required this.showLogoutButton,
    required this.hasSecurityNotification,
    required this.citizenshipUpgradeStatus,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        profile,
        score,
        pageCommand,
        showLogoutButton,
        hasSecurityNotification,
        citizenshipUpgradeStatus,
      ];

  ProfileState copyWith({
    PageState? pageState,
    String? errorMessage,
    ProfileModel? profile,
    ScoresViewModel? score,
    PageCommand? pageCommand,
    bool? showLogoutButton,
    bool? hasSecurityNotification,
    CitizenshipUpgradeStatus? citizenshipUpgradeStatus,
  }) {
    return ProfileState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      profile: profile ?? this.profile,
      score: score ?? this.score,
      pageCommand: pageCommand,
      showLogoutButton: showLogoutButton ?? this.showLogoutButton,
      hasSecurityNotification: hasSecurityNotification ?? this.hasSecurityNotification,
      citizenshipUpgradeStatus: citizenshipUpgradeStatus ?? this.citizenshipUpgradeStatus,
    );
  }

  factory ProfileState.initial() {
    return const ProfileState(
        pageState: PageState.initial,
        showLogoutButton: false,
        hasSecurityNotification: false,
        citizenshipUpgradeStatus: CitizenshipUpgradeStatus.notReady);
  }
}
