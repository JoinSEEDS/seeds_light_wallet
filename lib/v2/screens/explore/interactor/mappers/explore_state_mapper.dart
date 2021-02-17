import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/datasource/remote/model/voice_model_alliance.dart';
import 'package:seeds/v2/datasource/remote/model/voice_model_campaign.dart';
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
      print("ExploreStateMapper mapResultsToState length=" + results.length.toString());
      results.retainWhere((Result element) => element.isValue);
      List values = results.map((Result element) => element.asValue.value).toList();

      var balanceModel = values.firstWhere((element) => element is BalanceModel, orElse: () => null);
      var allianceVoice = values.firstWhere((element) => element is VoiceModelAlliance, orElse: () => null);
      var campaignVoice = values.firstWhere((element) => element is VoiceModelCampaign, orElse: () => null);

      return currentState.copyWith(
        pageState: PageState.success,
        // availableSeeds: balanceModel?.roundedQuantity,
        // allianceVoice: allianceVoice?.amount.toString(),
        // campaignVoice: campaignVoice?.amount.toString(),
      );
    }
  }
}
