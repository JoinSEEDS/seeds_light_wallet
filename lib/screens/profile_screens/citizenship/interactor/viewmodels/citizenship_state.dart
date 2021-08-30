import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/profile_screens/contribution/interactor/viewmodels/scores_view_model.dart';

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

/// --- STATE
class CitizenshipState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final ProfileModel? profile;
  final ScoresViewModel? score;
  final double? progressTimeline;
  final int? invitedVisitors;
  final int? invitedResidents;
  final double? plantedSeeds;
  final int? seedsTransactionsCount;

  const CitizenshipState({
    required this.pageState,
    this.errorMessage,
    this.profile,
    this.score,
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
        score,
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
    ScoresViewModel? score,
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
      score: score ?? this.score,
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
