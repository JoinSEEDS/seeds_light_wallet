import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/components/regions_map/components/regions_search_results/interactor/mappers/update_regions_results_state_mapper.dart';
import 'package:seeds/components/regions_map/components/regions_search_results/interactor/usecases/get_firebase_regions_use_case.dart';
import 'package:seeds/components/regions_map/interactor/view_models/place.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';

part 'regions_search_results_event.dart';
part 'regions_search_results_state.dart';

class RegionsSearchResultsBloc extends Bloc<RegionsSearchResultsEvent, RegionsSearchResultsState> {
  RegionsSearchResultsBloc(List<RegionModel> regions) : super(RegionsSearchResultsState.initial(regions)) {
    on<OnUpdateMapLocation>(_onUpdateMapLocations);
    on<ClearRegionsSearchResultsPageCommand>((_, emit) => emit(state.copyWith()));
  }

  Future<void> _onUpdateMapLocations(OnUpdateMapLocation event, Emitter<RegionsSearchResultsState> emit) async {
    final result = await GetFirebaseRegionsUseCase()
        .run(GetFirebaseRegionsUseCase.input(lat: event.place.lat, lng: event.place.lng, radius: 1000));
    emit(UpdateRegionsResultsStateMapper().mapResultToState(state, result, event.place));
  }
}
