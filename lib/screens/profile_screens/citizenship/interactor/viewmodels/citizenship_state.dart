part of 'citizenship_bloc.dart';

/// Resident requirements
const int residentRequiredReputation = 50;
const int residentRequiredVisitorsInvited = 1;
const int residentRequiredPlantedSeeds = 50;
const int residentRequiredSeedsTransactions = 1;

/// Citizen requirements
const int citizenRequiredReputation = 50;
const int citizenRequiredVisitorsInvited = 3;
const int citizenRequiredAccountAge = 60;
const int citizenRequiredPlantedSeeds = 200;
const int citizenRequiredSeedsTransactions = 5;
const int citizenRequiredCitizenVouched = 3;

class CitizenshipState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final ProfileModel? profile;
  final ScoreModel? reputationScore;
  final double? progressTimeline;
  final int? invitedVisitors;
  final int? citizenCeremony;
  final double? plantedSeeds;
  final int? seedsTransactionsCount;

  const CitizenshipState({
    required this.pageState,
    this.errorMessage,
    this.profile,
    this.reputationScore,
    this.progressTimeline,
    this.citizenCeremony,
    this.invitedVisitors,
    this.plantedSeeds,
    this.seedsTransactionsCount,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        profile,
        reputationScore,
        progressTimeline,
        citizenCeremony,
        invitedVisitors,
        plantedSeeds,
        seedsTransactionsCount,
      ];

  CitizenshipState copyWith({
    PageState? pageState,
    String? errorMessage,
    ProfileModel? profile,
    ScoreModel? reputationScore,
    double? progressTimeline,
    int? citizenCeremony,
    int? invitedVisitors,
    double? plantedSeeds,
    int? seedsTransactionsCount,
  }) {
    return CitizenshipState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      profile: profile ?? this.profile,
      reputationScore: reputationScore ?? this.reputationScore,
      progressTimeline: progressTimeline ?? this.progressTimeline,
      citizenCeremony: citizenCeremony ?? this.citizenCeremony,
      invitedVisitors: invitedVisitors ?? this.invitedVisitors,
      plantedSeeds: plantedSeeds ?? this.plantedSeeds,
      seedsTransactionsCount: seedsTransactionsCount ?? this.seedsTransactionsCount,
    );
  }

  factory CitizenshipState.initial() {
    return const CitizenshipState(pageState: PageState.initial);
  }
}
