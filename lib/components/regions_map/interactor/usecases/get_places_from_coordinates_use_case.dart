import 'package:geocoding/geocoding.dart';
import 'package:seeds/datasource/remote/geocoding_service.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class GetPlacesFromCoordinatesUseCase extends InputUseCase<List<Placemark>, _Input> {
  static _Input input({required double lat, required double lng, String? localeIdentifier}) =>
      _Input(lat: lat, lng: lng, localeIdentifier: localeIdentifier);

  @override
  Future<Result<List<Placemark>>> run(_Input input) async {
    return GeocodingService()
        .getPlacemarkFromCoordinates(input.lat, input.lng, localeIdentifier: input.localeIdentifier);
  }
}

class _Input {
  final double lat;
  final double lng;
  final String? localeIdentifier;

  const _Input({required this.lat, required this.lng, this.localeIdentifier});
}
