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
  final bool? isDHOMember;
  final String? errorMessage;

  const ExploreState({
    required this.pageState,
    this.availableSeeds,
    this.plantedSeeds,
    this.errorMessage,
    this.allianceVoice,
    this.isDHOMember,
    this.campaignVoice,
  });

  @override
  List<Object?> get props => [
        pageState,
        availableSeeds,
        plantedSeeds,
        errorMessage,
        allianceVoice,
        isDHOMember,
        campaignVoice,
      ];

  ExploreState copyWith({
    PageState? pageState,
    BalanceModel? availableSeeds,
    PlantedModel? plantedSeeds,
    String? allianceVoice,
    String? campaignVoice,
    bool? isDHOMember,
    String? errorMessage,
  }) {
    return ExploreState(
      pageState: pageState ?? this.pageState,
      availableSeeds: availableSeeds ?? this.availableSeeds,
      plantedSeeds: plantedSeeds ?? this.plantedSeeds,
      allianceVoice: allianceVoice ?? this.allianceVoice,
      campaignVoice: campaignVoice ?? this.campaignVoice,
      isDHOMember: isDHOMember ?? this.isDHOMember,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ExploreState.initial() {
    return const ExploreState(pageState: PageState.initial);
  }
}
