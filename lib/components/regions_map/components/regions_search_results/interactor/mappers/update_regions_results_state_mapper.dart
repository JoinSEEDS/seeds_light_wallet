import 'package:collection/collection.dart' show IterableExtension;
import 'package:seeds/components/regions_map/components/regions_search_results/interactor/viewmodels/page_commands.dart';
import 'package:seeds/components/regions_map/components/regions_search_results/interactor/viewmodels/regions_search_results_bloc.dart';
import 'package:seeds/components/regions_map/interactor/view_models/place.dart';
import 'package:seeds/datasource/remote/model/firebase_models/firebase_region_model.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';

class UpdateRegionsResultsStateMapper extends StateMapper {
  RegionsSearchResultsState mapResultToState(RegionsSearchResultsState currentState, Result result, Place place) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, pageCommand: ShowErrorMessage(''));
    } else {
      final List<FirebaseRegion> fireRegions = result.asValue!.value as List<FirebaseRegion>;
      final List<RegionModel> newRegions = [];
      for (final i in fireRegions) {
        final found = currentState.regions.singleWhereOrNull((r) => r.id == i.id);
        if (found != null) {
          newRegions.add(found.addImageUrlToModel(i.imageUrl));
        }
      }
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: RegionsChanged(),
        nearbyRegions: newRegions,
        currentPlace: place,
      );
    }
  }
}
