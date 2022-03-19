import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:equatable/equatable.dart';
import 'package:seeds/components/regions_map/interactor/view_models/place.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/regions_screens/join_region/interactor/usecases/get_firebase_regions_use_case.dart';
import 'package:seeds/screens/explore_screens/regions_screens/join_region/interactor/usecases/get_regions_use_case.dart';

part 'join_region_event.dart';
part 'join_region_state.dart';

class JoinRegionBloc extends Bloc<JoinRegionEvent, JoinRegionState> {
  JoinRegionBloc() : super(JoinRegionState.initial()) {
    on<OnLoadRegions>(_onLoadRegions);
    on<OnUpdateMapLocation>(_onUpdateMapLocations);
  }

  Future<void> _onLoadRegions(OnLoadRegions event, Emitter<JoinRegionState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final result = await GetRegionsUseCase().run();
    if (result.isError) {
      emit(state.copyWith(pageState: PageState.failure));
    } else {
      emit(state.copyWith(pageState: PageState.success, regions: result.asValue!.value));
    }
  }

  Future<void> _onUpdateMapLocations(OnUpdateMapLocation event, Emitter<JoinRegionState> emit) async {
    final result = await GetFirebaseRegionsUseCase()
        .run(GetFirebaseRegionsUseCase.input(lat: event.place.lat, lng: event.place.lng, radius: 1000));
    if (result.isError) {
      emit(state.copyWith(pageState: PageState.failure));
    } else {
      final fireRegions = result.asValue!.value;
      final List<RegionModel> newRegions = [];
      for (final i in fireRegions) {
        final found = state.regions.singleWhereOrNull((r) => r.id == i.locationId);
        if (found != null) {
          newRegions.add(found.addImageUrlToModel(i.imageUrl));
        }
      }
      emit(state.copyWith(regions: newRegions, currentPlace: event.place));
    }
  }
}
