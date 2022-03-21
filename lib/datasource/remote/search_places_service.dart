import 'dart:math';

import 'package:async/async.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:seeds/utils/result_extension.dart';

class SearchPlacesService {
  /// optional - sets 'proxy' value in google_maps_webservice
  ///
  /// In case of using a proxy the baseUrl can be set.
  /// The apiKey is not required in case the proxy sets it.
  /// (Not storing the apiKey in the app is good practice)
  /// String proxyBaseUrl;

  /// optional - set 'client' value in google_maps_webservice
  ///
  /// In case of using a proxy url that requires authentication
  /// or custom configuration
  /// BaseClient httpClient;
  ///
  final _places = GoogleMapsPlaces(apiKey: 'AIzaSyB3Ghs8i_Lw55vmSyh5mxLA9cGcWuc1A54');

  Future<Result<PlacesAutocompleteResponse>> getPlacesAutocomplete(
    String input, {
    String? sessionToken,
    num? offset,
    Location? origin,
    Location? location,
    num radius = 200000, // 200 km
    String? language,
    List<String> types = const [],
    List<Component> components = const [],
    bool strictbounds = false,
    String? region,
  }) async {
    try {
      final response = await _places.autocomplete(
        input,
        sessionToken: _Uuid().generateV4(),
        offset: offset,
        origin: origin,
        location: location,
        radius: radius,
        language: language,
        types: types,
        components: components,
        strictbounds: strictbounds,
        region: region,
      );
      return Result.value(response);
    } catch (e) {
      print('Error getting places from coordinates');
      return Result.error(e);
    }
  }

  Future<Result<PlacesDetailsResponse>> getPlaceDetails(String placeId) async {
    try {
      final response = await _places.getDetailsByPlaceId(placeId);
      return Result.value(response);
    } catch (e) {
      print('Error getting places from coordinates');
      return Result.error(e);
    }
  }
}

class _Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) => _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) => value.toRadixString(16).padLeft(count, '0');
}
