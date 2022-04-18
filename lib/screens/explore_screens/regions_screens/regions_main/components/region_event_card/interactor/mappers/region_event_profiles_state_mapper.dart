import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/components/region_event_card/interactor/viewmodels/region_event_card_bloc.dart';

class RegionEventProfileMembersStateMapper extends StateMapper {
  RegionEventCardState mapResultsToState({required RegionEventCardState currentState, required Result result}) {
    final List<ProfileModel> profiles = result.asValue?.value ?? [];
    return currentState.copyWith(profiles: profiles);
  }
}
