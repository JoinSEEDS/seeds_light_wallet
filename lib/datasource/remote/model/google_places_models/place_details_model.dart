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
      result: PlaceDetails.fromJson(json['result']),
      status: json['status'],
      errorMessage: json['error_message'],
    );
  }
}

class PlaceDetails {
  final Geometry geometry;

  const PlaceDetails(this.geometry);

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    return PlaceDetails(Geometry.fromJson(json['geometry']));
  }
}

class Geometry {
  final Location location;

  const Geometry(this.location);

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(Location.fromJson(json['location']));
  }
}

class Location {
  final double lat;
  final double lng;

  const Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(lat: json['lat'], lng: json['lng']);
  }

  @override
  String toString() => '$lat,$lng';
}
