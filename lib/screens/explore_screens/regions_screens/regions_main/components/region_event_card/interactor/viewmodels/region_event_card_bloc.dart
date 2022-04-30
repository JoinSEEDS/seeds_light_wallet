import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/firebase/regions/firebase_database_regions_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_event_model.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/components/region_event_card/interactor/mappers/region_event_profiles_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/components/region_event_card/interactor/usecases/get_first_n_profiles_elements_use_case.dart';

part 'region_event_card_event.dart';
part 'region_event_card_state.dart';

class RegionEventCardBloc extends Bloc<RegionEventCardEvent, RegionEventCardState> {
  late StreamSubscription<List<RegionEventModel>> _eventListener;

  RegionEventCardBloc(RegionEventModel event) : super(RegionEventCardState.initial()) {
    _eventListener = FirebaseDatabaseRegionsRepository().getEventsForRegion(event.regionAccount).listen((events) {
      final found = events.singleWhereOrNull((i) => i.id == event.id);
      if (found != null) {
        add(OnLoadRegionEventMembers(found.users));
      }
    });

    on<OnLoadRegionEventMembers>(_onLoadRegionEventMembers);
  }

  @override
  Future<void> close() {
    _eventListener.cancel();
    return super.close();
  }

  Future<void> _onLoadRegionEventMembers(OnLoadRegionEventMembers event, Emitter<RegionEventCardState> emit) async {
    if (event.eventUsers.isNotEmpty) {
      final result =
          await GetFirstNProfilesElementsUseCase().run(GetFirstNProfilesElementsUseCase.input(event.eventUsers, 3));
      emit(RegionEventProfileMembersStateMapper().mapResultsToState(currentState: state, result: result));
    }
  }
}
