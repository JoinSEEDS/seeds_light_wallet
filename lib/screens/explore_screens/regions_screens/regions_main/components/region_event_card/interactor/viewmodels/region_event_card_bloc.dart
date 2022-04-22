import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/components/region_event_card/interactor/mappers/region_event_profiles_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/components/region_event_card/interactor/usecases/get_first_n_profiles_elements_use_case.dart';

part 'region_event_card_event.dart';
part 'region_event_card_state.dart';

class RegionEventCardBloc extends Bloc<RegionEventCardEvent, RegionEventCardState> {
  RegionEventCardBloc() : super(RegionEventCardState.initial()) {
    on<OnLoadRegionEventMembers>(_onLoadRegionEventMembers);
  }

  Future<void> _onLoadRegionEventMembers(OnLoadRegionEventMembers event, Emitter<RegionEventCardState> emit) async {
    if (event.eventUsers.isNotEmpty) {
      final result =
          await GetFirstNProfilesElementsUseCase().run(GetFirstNProfilesElementsUseCase.input(event.eventUsers, 3));
      emit(RegionEventProfileMembersStateMapper().mapResultsToState(currentState: state, result: result));
    }
  }
}
