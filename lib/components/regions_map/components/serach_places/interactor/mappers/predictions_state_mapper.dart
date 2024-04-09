import 'package:seeds/components/regions_map/components/serach_places/interactor/view_models/search_places_bloc.dart';
import 'package:seeds/datasource/remote/model/google_places_models/prediction_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';

class PredictionsStateMapper extends StateMapper {
  SearchPlacesState mapResultToState(
      SearchPlacesState currentState, Result result, List<PredictionModel> regionMatches) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, showLinearIndicator: false);
    } else {
      final PlacesAutocompleteResponse response = result.asValue!.value as PlacesAutocompleteResponse;
      return currentState.copyWith(
        pageState: PageState.success,
        showLinearIndicator: false,
        predictions: regionMatches + response.predictions,
      );
    }
  }
}
