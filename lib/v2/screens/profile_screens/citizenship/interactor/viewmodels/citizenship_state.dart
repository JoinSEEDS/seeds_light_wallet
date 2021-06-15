import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/datasource/remote/model/score_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

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
  final ScoreModel? score;
  final double? progressTimeline;
  final int? invitedVisitors;
  final int? invitedResidents;

  const CitizenshipState({
    required this.pageState,
    this.errorMessage,
    this.profile,
    this.score,
    this.progressTimeline,
    this.invitedResidents,
    this.invitedVisitors,
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
      ];

  CitizenshipState copyWith({
    PageState? pageState,
    String? errorMessage,
    ProfileModel? profile,
    ScoreModel? score,
    double? progressTimeline,
    int? invitedResidents,
    int? invitedVisitors,
  }) {
    return CitizenshipState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      profile: profile ?? this.profile,
      score: score ?? this.score,
      progressTimeline: progressTimeline ?? this.progressTimeline,
      invitedResidents: invitedResidents ?? this.invitedResidents,
      invitedVisitors: invitedVisitors ?? this.invitedVisitors,
    );
  }

  factory CitizenshipState.initial() {
    return const CitizenshipState(pageState: PageState.initial);
  }
}
