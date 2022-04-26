import 'package:collection/collection.dart' show IterableExtension;
import 'package:seeds/components/regions_map/interactor/view_models/place.dart';
import 'package:seeds/datasource/remote/model/firebase_models/firebase_region_model.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/join_region/interactor/viewmodels/join_region_bloc.dart';

class UpdateRegionsResultsStateMapper extends StateMapper {
  JoinRegionState mapResultToState(JoinRegionState currentState, Result result, Place place) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure);
    } else {
      final List<FirebaseRegion> fireRegions = result.asValue!.value;
      final List<RegionModel> newRegions = [];
      for (final i in fireRegions) {
        final found = currentState.regions.singleWhereOrNull((r) => r.id == i.id);
        if (found != null) {
          newRegions.add(found.addImageUrlToModel(i.imageUrl));
        }
      }
      return currentState.copyWith(regions: newRegions, currentPlace: place);
    }
  }
}
