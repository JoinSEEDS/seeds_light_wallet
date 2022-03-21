import 'package:google_maps_webservice/places.dart';
import 'package:seeds/datasource/remote/search_places_service.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class GetPlaceDetailsUseCase extends InputUseCase<PlacesDetailsResponse, _Input> {
  static _Input input(String placeId) => _Input(placeId);

  @override
  Future<Result<PlacesDetailsResponse>> run(_Input input) async {
    return SearchPlacesService().getPlaceDetails(input.placeId);
  }
}

class _Input {
  final String placeId;
  const _Input(this.placeId);
}
