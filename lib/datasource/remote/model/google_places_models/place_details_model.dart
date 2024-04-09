class PlacesDetailsResponse {
  final PlaceDetails result;
  final String status;
  final String? errorMessage;

  const PlacesDetailsResponse({
    required this.result,
    required this.status,
    this.errorMessage,
  });

  factory PlacesDetailsResponse.fromJson(Map<String, dynamic> json) {
    return PlacesDetailsResponse(
      result: PlaceDetails.fromJson(json['result'] as Map<String, dynamic> ),
      status: json['status'] as String,
      errorMessage: json['error_message'] as String?,
    );
  }
}

class PlaceDetails {
  final Geometry geometry;

  const PlaceDetails(this.geometry);

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    return PlaceDetails(Geometry.fromJson(json['geometry'] as Map<String, dynamic> ));
  }
}

class Geometry {
  final Location location;

  const Geometry(this.location);

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(Location.fromJson(json['location'] as Map<String, dynamic> ));
  }
}

class Location {
  final double lat;
  final double lng;

  const Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(lat: json['lat'] as double, lng: json['lng'] as double);
  }

  @override
  String toString() => '$lat,$lng';
}
