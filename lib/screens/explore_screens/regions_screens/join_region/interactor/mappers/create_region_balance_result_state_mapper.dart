import 'package:seeds/datasource/remote/model/balance_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/join_region/interactor/viewmodels/join_region_bloc.dart';
import 'package:seeds/screens/explore_screens/regions_screens/join_region/interactor/viewmodels/join_region_page_command.dart';

class CreateRegionBalanceResultStateMapper extends StateMapper {
  JoinRegionState mapResultToState(JoinRegionState currentState, Result<BalanceModel> result) {
    if (result.isError) {
      return currentState.copyWith(
          isCreateRegionButtonLoading: false, pageCommand: ShowErrorMessage("Error Loading Balance"));
    } else {
      if (result.asValue!.value.quantity > 1000) {
        return currentState.copyWith(isCreateRegionButtonLoading: false, pageCommand: ShowCreateRegionInfo());
      } else {
        return currentState.copyWith(isCreateRegionButtonLoading: false, pageCommand: ShowNotEnoughSeedsDialog());
      }
    }
  }
}
