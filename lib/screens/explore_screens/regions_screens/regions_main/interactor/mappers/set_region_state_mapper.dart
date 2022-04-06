import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/interactor/viewmodel/region_bloc.dart';

class SetRegionStateMapper extends StateMapper {
  RegionState mapResultToState(RegionState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure);
    } else {
      final RegionModel region = result.asValue!.value;
      return currentState.copyWith(pageState: PageState.success, isBrowseView: false, region: region);
    }
  }
}
