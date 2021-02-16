import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/results_to_state_mapper.dart';
import 'package:seeds/v2/screens/explore/interactor/viewmodels/explore_state.dart';
import 'package:seeds/v2/screens/profile/interactor/usecases/get_profile_use_case.dart';

class ExploreStateMapper extends ResultsToStateMapper<ExploreState> {
  @override
  ExploreState mapResultsToState(ExploreState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error Loading Page");
    } else {
      print("ExploreStateMapper mapResultsToState ");
      results.retainWhere((Result element) => element.isValue);
      print("ExploreStateMapper mapResultsToState lenght" + results.length.toString());

      BalanceModel balanceModel =
          results.firstWhere((Result element) => element.asValue.value is BalanceModel, orElse: null).asValue.value;
      print("ExploreStateMapper mapResultsToState balanceModel" + balanceModel.toString());
      // VoiceModelAlliance allianceVoice = results
      //     .firstWhere((Result element) => element.asValue.value is VoiceModelAlliance, orElse: null)
      //     .asValue
      //     .value;
      // VoiceModelCampaign campaignVoice = results
      //     .firstWhere((Result element) => element.asValue.value is VoiceModelCampaign, orElse: null)
      //     .asValue
      //     .value;

      return currentState.copyWith(
        pageState: PageState.success,
        availableSeeds: balanceModel.roundedQuantity,
        // allianceVoice: allianceVoice ?? allianceVoice.amount,
        // campaignVoice: campaignVoice ?? campaignVoice.amount,
      );
    }
  }
}
