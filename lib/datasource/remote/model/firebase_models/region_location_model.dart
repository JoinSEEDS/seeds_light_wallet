import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

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
    final GeoPoint geoPoint = data['point']['geopoint'];
    return RegionLocation(
      regionAccount: data['regionAccount'],
      dateCreated: data['dateCreated'],
      geoPoint: GeoFirePoint(geoPoint.latitude, geoPoint.longitude),
    );
  }

  double distanceTo(double lat, double lng) => geoPoint.distance(lat: lat, lng: lng);

}
