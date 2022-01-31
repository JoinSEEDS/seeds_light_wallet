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
const int citizenRequiredResidentsInvited = 1;

class CitizenshipState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final ProfileModel? profile;
  final ScoreModel? reputationScore;
  final double? progressTimeline;
  final int? invitedVisitors;
  final int? invitedResidents;
  final double? plantedSeeds;
  final int? seedsTransactionsCount;

  const CitizenshipState({
    required this.pageState,
    this.errorMessage,
    this.profile,
    this.reputationScore,
    this.progressTimeline,
    this.invitedResidents,
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
        invitedResidents,
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
    int? invitedResidents,
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
      invitedResidents: invitedResidents ?? this.invitedResidents,
      invitedVisitors: invitedVisitors ?? this.invitedVisitors,
      plantedSeeds: plantedSeeds ?? this.plantedSeeds,
      seedsTransactionsCount: seedsTransactionsCount ?? this.seedsTransactionsCount,
    );
  }

  factory CitizenshipState.initial() {
    return const CitizenshipState(pageState: PageState.initial);
  }
}
