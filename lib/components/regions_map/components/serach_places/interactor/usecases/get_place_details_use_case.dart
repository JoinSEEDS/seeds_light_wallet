import 'package:seeds/datasource/remote/api/google_places_repository.dart';
import 'package:seeds/datasource/remote/model/google_places_models/place_details_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class GetPlaceDetailsUseCase extends InputUseCase<PlacesDetailsResponse, _Input> {
  static _Input input(String placeId) => _Input(placeId);

  @override
  Future<Result<PlacesDetailsResponse>> run(_Input input) async {
    return GoogleMapsPlacesRepository().getDetailsByPlaceId(input.placeId);
  }
}

class _Input {
  final String placeId;
  const _Input(this.placeId);
}
