import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class RegionLocation {
  final String regionAccount;
  final Timestamp dateCreated;
  final GeoFirePoint geoPoint;

  RegionLocation({
    required this.regionAccount,
    required this.dateCreated,
    required this.geoPoint,
  });

  RegionLocation.fromMap(Map<String, dynamic> data)
      : this(
          regionAccount: data['regionAccount'],
          dateCreated: data['dateCreated'],
          geoPoint: data['point'],
        );

  double distanceTo(double lat, double lng) => geoPoint.kmDistance(lat: lat, lng: lng);
}
