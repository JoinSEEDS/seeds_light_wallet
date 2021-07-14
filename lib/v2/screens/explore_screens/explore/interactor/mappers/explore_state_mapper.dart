import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/datasource/remote/model/planted_model.dart';
import 'package:seeds/v2/datasource/remote/model/voice_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/explore_screens/explore/interactor/viewmodels/explore_state.dart';
import 'package:seeds/v2/i18n/explore_screens/explore/explore.i18n.dart';

class ExploreStateMapper extends StateMapper {
  ExploreState mapResultsToState(ExploreState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page'.i18n);
    } else {
      results.retainWhere((Result i) => i.isValue);
      var values = results.map((Result i) => i.asValue!.value).toList();

      BalanceModel? balanceModel = values.firstWhere((i) => i is BalanceModel, orElse: () => null);
      PlantedModel? plantedSeeds = values.firstWhere((i) => i is PlantedModel, orElse: () => null);
      List<VoiceModel> voiceModels = values.whereType<VoiceModel>().toList();
      bool? isDHOMember = values.firstWhere((i) => i is bool, orElse: () => null);

      return currentState.copyWith(
        pageState: PageState.success,
        availableSeeds: balanceModel,
        plantedSeeds: plantedSeeds,
        allianceVoice: voiceModels.first.amount.toString(),
        campaignVoice: voiceModels.last.amount.toString(),
        isDHOMember: isDHOMember,
      );
    }
  }
}
