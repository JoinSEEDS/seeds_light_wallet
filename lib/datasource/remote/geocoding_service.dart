import 'package:async/async.dart';
import 'package:geocoding/geocoding.dart';

class GeocodingService {
  Future<Result<List<Placemark>>> getPlacemarkFromCoordinates(
    double lat,
    double lng, {
    String? localeIdentifier,
  }) async {
    try {
      return Result.value(await placemarkFromCoordinates(lat, lng, localeIdentifier: localeIdentifier));
   } catch (e) {
      print('Error getting places from coordinates $e');
      return Result.error(e);
    }
  }
}
