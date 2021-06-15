import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/datasource/remote/model/planted_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class ExploreState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final BalanceModel? availableSeeds;
  final PlantedModel? plantedSeeds;
  final String? allianceVoice;
  final String? campaignVoice;
  final bool? isDHOMember;

  const ExploreState({
    required this.pageState,
    this.errorMessage,
    this.availableSeeds,
    this.plantedSeeds,
    this.allianceVoice,
    this.isDHOMember,
    this.campaignVoice,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        availableSeeds,
        plantedSeeds,
        allianceVoice,
        isDHOMember,
        campaignVoice,
      ];

  ExploreState copyWith({
    PageState? pageState,
    String? errorMessage,
    BalanceModel? availableSeeds,
    PlantedModel? plantedSeeds,
    String? allianceVoice,
    String? campaignVoice,
    bool? isDHOMember,
  }) {
    return ExploreState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      availableSeeds: availableSeeds ?? this.availableSeeds,
      plantedSeeds: plantedSeeds ?? this.plantedSeeds,
      allianceVoice: allianceVoice ?? this.allianceVoice,
      campaignVoice: campaignVoice ?? this.campaignVoice,
      isDHOMember: isDHOMember ?? this.isDHOMember,
    );
  }

  factory ExploreState.initial() {
    return const ExploreState(pageState: PageState.initial);
  }
}
