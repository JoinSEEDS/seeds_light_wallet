class Place {
  final double lng;
  final double lat;
  final String placeText;

  const Place({required this.lng, required this.lat, required this.placeText});

  Place copyWith({double? lng, double? lat, String? placeText}) {
    return Place(
      lng: lng ?? this.lng,
      lat: lat ?? this.lat,
      placeText: placeText ?? this.placeText,
    );
  }
}
