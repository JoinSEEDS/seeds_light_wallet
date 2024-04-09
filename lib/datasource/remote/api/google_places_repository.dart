import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/model/google_places_models/place_details_model.dart';
import 'package:seeds/datasource/remote/model/google_places_models/prediction_model.dart';

class GoogleMapsPlacesRepository extends HttpRepository {
  Future<Result<PlacesAutocompleteResponse>> autocomplete(
    String input, {
    String? sessionToken,
    num? offset,
    Location? origin,
    Location? location,
    num? radius,
    String? language,
    List<String> types = const [],
    List<Component> components = const [],
    bool strictbounds = false,
    String? region,
  }) {
    print('[http] - get autocomplete results');

    final params = <String, String>{'input': input};

    if (language != null) {
      params['language'] = language;
    }
    if (origin != null) {
      params['origin'] = origin.toString();
    }
    if (location != null) {
      params['location'] = location.toString();
    }
    if (radius != null) {
      params['radius'] = radius.toString();
    }
    if (types.isNotEmpty) {
      params['types'] = types.join('|');
    }
    if (components.isNotEmpty) {
      params['components'] = components.join('|');
    }
    if (strictbounds) {
      params['strictbounds'] = strictbounds.toString();
    }
    if (offset != null) {
      params['offset'] = offset.toString();
    }
    if (region != null) {
      params['region'] = region;
    }
    if (sessionToken != null) {
      params['sessiontoken'] = sessionToken;
    }
    params['key'] = mapsApiKey;

    return http
        .get(Uri.https('maps.googleapis.com', '/maps/api/place/autocomplete/json', params))
        .then((http.Response response) => mapHttpResponse<PlacesAutocompleteResponse>(response, (Map<String, dynamic> body) {
              return PlacesAutocompleteResponse.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<PlacesDetailsResponse>> getDetailsByPlaceId(String placeId) {
    print('[http] - get place details by id - place id: $placeId');

    return http
        .get(Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$mapsApiKey'))
        .then((http.Response response) => mapHttpResponse<PlacesDetailsResponse>(response, (Map<String, dynamic> body) {
              return PlacesDetailsResponse.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }
}
