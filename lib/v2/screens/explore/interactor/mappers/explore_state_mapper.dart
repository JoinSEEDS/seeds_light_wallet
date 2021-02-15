import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/datasource/remote/model/voice_model_alliance.dart';
import 'package:seeds/v2/datasource/remote/model/voice_model_campaign.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/results_to_state_mapper.dart';
import 'package:seeds/v2/domain-shared/state_mapper.dart';
import 'package:seeds/v2/screens/explore/interactor/viewmodels/explore_state.dart';
import 'package:seeds/v2/screens/profile/interactor/usecases/get_profile_use_case.dart';

class ExploreStateMapper extends ResultsToStateMapper<ExploreState> {
  @override
  ExploreState mapResultsToState(ExploreState currentState, List<Result> results) {
    if (isAllThereError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error Loading Page");
    } else {
      results.retainWhere((Result element) => element.isValue);

      BalanceModel balanceModel =
          results.firstWhere((Result element) => element.asValue.value is BalanceModel, orElse: null).asValue.value;
      VoiceModelAlliance allianceVoice = results
          .firstWhere((Result element) => element.asValue.value is VoiceModelAlliance, orElse: null)
          .asValue
          .value;
      VoiceModelCampaign campaignVoice = results
          .firstWhere((Result element) => element.asValue.value is VoiceModelCampaign, orElse: null)
          .asValue
          .value;

      return currentState.copyWith(
          pageState: PageState.success,
          availableSeeds: balanceModel ?? balanceModel.formattedQuantity,
          allianceVoice: allianceVoice ?? allianceVoice.amount,
          campaignVoice: campaignVoice ?? campaignVoice.amount);
    }
  }
}
