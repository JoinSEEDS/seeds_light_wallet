import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/datasource/remote/model/planted_model.dart';
import 'package:seeds/v2/datasource/remote/model/voice_model_alliance.dart';
import 'package:seeds/v2/datasource/remote/model/voice_model_campaign.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/explore/interactor/viewmodels/explore_state.dart';

class ExploreStateMapper extends StateMapper {
  ExploreState mapResultsToState(ExploreState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page');
    } else {
      print('ExploreStateMapper mapResultsToState length=' + results.length.toString());
      results.retainWhere((Result element) => element.isValue);
      var values = results.map((Result element) => element.asValue.value).toList();

      BalanceModel balanceModel = values.firstWhere((element) => element is BalanceModel, orElse: () => null);
      VoiceModelAlliance allianceVoice =
          values.firstWhere((element) => element is VoiceModelAlliance, orElse: () => null);
      VoiceModelCampaign campaignVoice =
          values.firstWhere((element) => element is VoiceModelCampaign, orElse: () => null);
      PlantedModel plantedSeeds = values.firstWhere((element) => element is PlantedModel, orElse: () => null);

      return currentState.copyWith(
        pageState: PageState.success,
        availableSeeds: balanceModel?.roundedQuantity,
        allianceVoice: allianceVoice?.amount.toString(),
        campaignVoice: campaignVoice?.amount.toString(),
        plantedSeeds: plantedSeeds?.quantity.toString(),
      );
    }
  }
}
