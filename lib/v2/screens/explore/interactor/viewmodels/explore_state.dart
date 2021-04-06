import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class ExploreState extends Equatable {
  final PageState pageState;
  final String availableSeeds;
  final String allianceVoice;
  final String campaignVoice;
  final String errorMessage;
  final String plantedSeeds;

  const ExploreState({
    @required this.pageState,
    this.availableSeeds,
    this.errorMessage,
    this.allianceVoice,
    this.campaignVoice,
    this.plantedSeeds,
  });

  @override
  List<Object> get props => [pageState, availableSeeds, errorMessage, allianceVoice, campaignVoice];

  ExploreState copyWith({
    PageState pageState,
    String availableSeeds,
    String allianceVoice,
    String campaignVoice,
    String errorMessage,
    String plantedSeeds,
  }) {
    return ExploreState(
      pageState: pageState ?? this.pageState,
      availableSeeds: availableSeeds ?? this.availableSeeds,
      allianceVoice: allianceVoice ?? this.allianceVoice,
      campaignVoice: campaignVoice ?? this.campaignVoice,
      errorMessage: errorMessage ?? this.errorMessage,
      plantedSeeds: plantedSeeds ?? this.plantedSeeds,
    );
  }

  factory ExploreState.initial() {
    return const ExploreState(
      pageState: PageState.initial,
      availableSeeds: null,
      campaignVoice: null,
      allianceVoice: null,
      errorMessage: null,
      plantedSeeds: null,
    );
  }
}
