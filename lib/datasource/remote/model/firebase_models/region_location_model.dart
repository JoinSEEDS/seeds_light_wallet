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

  factory RegionLocation.fromMap(Map<String, dynamic> data) {
    final GeoPoint geoPoint = data['point']['geopoint'] as GeoPoint;
    return RegionLocation(
      regionAccount: data['regionAccount'] as String,
      dateCreated: data['dateCreated'] as Timestamp,
      geoPoint: GeoFirePoint(geoPoint.latitude, geoPoint.longitude),
    );
  }

  double distanceTo(double lat, double lng) => geoPoint.kmDistance(lat: lat, lng: lng);

}
