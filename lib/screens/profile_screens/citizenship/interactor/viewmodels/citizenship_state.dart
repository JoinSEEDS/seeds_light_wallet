part of 'citizenship_bloc.dart';

/// Resident requirements
const int resident_required_reputation = 50;
const int resident_required_visitors_invited = 1;
const int resident_required_planted_seeds = 50;
const int resident_required_seeds_transactions = 1;

/// Citizen requirements
const int citizen_required_reputation = 50;
const int citizen_required_visitors_invited = 3;
const int citizen_required_account_age = 60;
const int citizen_required_planted_seeds = 200;
const int citizen_required_seeds_transactions = 5;
const int citizen_required_residents_invited = 1;

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
