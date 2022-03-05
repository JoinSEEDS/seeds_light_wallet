import 'package:cloud_firestore/cloud_firestore.dart';

class RegionLocation {
  final String regionAccount;
  final Timestamp dateCreated;
  final GeoPoint geoPoint;

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
}
