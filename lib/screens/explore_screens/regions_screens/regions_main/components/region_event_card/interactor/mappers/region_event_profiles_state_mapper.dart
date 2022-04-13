import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/components/region_event_card/interactor/viewmodels/region_event_card_bloc.dart';

class RegionEventProfileMembersStateMapper extends StateMapper {
  RegionEventCardState mapResultsToState({required RegionEventCardState currentState, required List<Result> results}) {
    if (areAllResultsError(results)) {
      return currentState;
    } else {
      final List<ProfileModel> profiles = results
          .where((Result result) => result.isValue)
          .map((Result result) => result.asValue!.value as ProfileModel)
          .toList();

      return currentState.copyWith(profiles: profiles);
    }
  }
}
