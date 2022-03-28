import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/join_region/interactor/viewmodels/join_region_bloc.dart';

class SetRegionsStateMapper extends StateMapper {
  JoinRegionState mapResultToState(JoinRegionState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure);
    } else {
      final List<RegionModel> regions = result.asValue!.value;
      return currentState.copyWith(pageState: PageState.success, regions: regions);
    }
  }
}
