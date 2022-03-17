import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/components/regions_map/interactor/view_models/place.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
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
    // TODO(Raul): logic to be enabled once Gery add method to get region image url
    // final result = await GetFirebaseRegionsUseCase()
    //     .run(GetFirebaseRegionsUseCase.input(lat: event.place.lat, lng: event.place.lng, radius: 2000000));
    // if (result.isError) {
    //   emit(state.copyWith(pageState: PageState.failure));
    // } else {
    //   final fireRegions = result.asValue!.value;
    //   final List<RegionModel> newRegions = [];
    //   for (final i in fireRegions) {
    //     final found = state.regions.singleWhereOrNull((r) =>r.id==i.regionAccount );
    //     if (found!=null) {
    //       newRegions.add(found.addImageUrlToModel(i.));
    //     }
    //   }
    //   emit(state.copyWith(pageState: PageState.failure));
    // }
    emit(state.copyWith(
        currentPlace: event.place,
        // Dummy image to remove later
        regions: state.regions
            .map((i) => i.addImageUrlToModel(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/8/80/Dark-forest-combo-1.JPG/1024px-Dark-forest-combo-1.JPG'))
            .toList()));
  }
}
