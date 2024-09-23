part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final ProfileModel? profile;
  final ScoreModel? contributionScore;
  final bool isOrganization;
  final bool showLogoutButton;
  final bool hasSecurityNotification;
  final CitizenshipUpgradeStatus citizenshipUpgradeStatus;
  final bool isImportAccountEnabled;
  bool get showCitizenCard => !(profile == null
   || profile?.status == ProfileStatus.citizen
   || profile?.status == ProfileStatus.unknown
   || isOrganization);

  const ProfileState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    this.profile,
    this.contributionScore,
    required this.isOrganization,
    required this.showLogoutButton,
    required this.hasSecurityNotification,
    required this.citizenshipUpgradeStatus,
    required this.isImportAccountEnabled,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        profile,
        contributionScore,
        isOrganization,
        showLogoutButton,
        hasSecurityNotification,
        citizenshipUpgradeStatus,
        isImportAccountEnabled,
        showCitizenCard,
        showShimmer,
        accountStatus,
      ];

  bool get showShimmer => pageState == PageState.loading || pageState == PageState.initial;

  String get accountStatus => isOrganization ? 'Organization' : profile?.statusString ?? '';

  ProfileState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    ProfileModel? profile,
    ScoreModel? contributionScore,
    bool? isOrganization,
    bool? showLogoutButton,
    bool? hasSecurityNotification,
    CitizenshipUpgradeStatus? citizenshipUpgradeStatus,
    bool? isImportAccountEnabled,
  }) {
    return ProfileState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      profile: profile ?? this.profile,
      contributionScore: contributionScore ?? this.contributionScore,
      isOrganization: isOrganization ?? this.isOrganization,
      showLogoutButton: showLogoutButton ?? this.showLogoutButton,
      hasSecurityNotification: hasSecurityNotification ?? this.hasSecurityNotification,
      citizenshipUpgradeStatus: citizenshipUpgradeStatus ?? this.citizenshipUpgradeStatus,
      isImportAccountEnabled: isImportAccountEnabled ?? this.isImportAccountEnabled,
    );
  }

  factory ProfileState.initial(bool isImportAccountEnabled) {
    return ProfileState(
      pageState: PageState.initial,
      isOrganization: false,
      showLogoutButton: false,
      hasSecurityNotification: false,
      citizenshipUpgradeStatus: CitizenshipUpgradeStatus.notReady,
      isImportAccountEnabled: isImportAccountEnabled,
    );
  }
}

enum CitizenshipUpgradeStatus { notReady, canResident, canCitizen }
