import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/datasource/remote/model/planted_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class ExploreState extends Equatable {
  final PageState pageState;
  final BalanceModel? availableSeeds;
  final PlantedModel? plantedSeeds;
  final String? allianceVoice;
  final String? campaignVoice;
  final String? errorMessage;

  const ExploreState({
    required this.pageState,
    this.availableSeeds,
    this.plantedSeeds,
    this.errorMessage,
    this.allianceVoice,
    this.campaignVoice,
  });

  @override
  List<Object?> get props => [
        pageState,
        availableSeeds,
        plantedSeeds,
        errorMessage,
        allianceVoice,
        campaignVoice,
      ];

  ExploreState copyWith({
    PageState? pageState,
    BalanceModel? availableSeeds,
    PlantedModel? plantedSeeds,
    String? allianceVoice,
    String? campaignVoice,
    String? errorMessage,
  }) {
    return ExploreState(
      pageState: pageState ?? this.pageState,
      availableSeeds: availableSeeds ?? this.availableSeeds,
      plantedSeeds: plantedSeeds ?? this.plantedSeeds,
      allianceVoice: allianceVoice ?? this.allianceVoice,
      campaignVoice: campaignVoice ?? this.campaignVoice,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ExploreState.initial() {
    return const ExploreState(pageState: PageState.initial);
  }
}
