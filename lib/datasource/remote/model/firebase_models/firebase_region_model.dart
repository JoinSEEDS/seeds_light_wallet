import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeds/datasource/remote/firebase/regions/firebase_database_regions_repository.dart';

class FirebaseRegion {
  final String creatorAccount;
  final Timestamp dateCreated;
  final GeoPoint geoPoint;
  final String imageUrl;
  final String locationId;

  const FirebaseRegion({
    required this.creatorAccount,
    required this.dateCreated,
    required this.geoPoint,
    required this.imageUrl,
    required this.locationId,
  });

  factory FirebaseRegion.fromMap(Map<String, dynamic> data) {
    return FirebaseRegion(
      creatorAccount: data[creatorAccountKey],
      dateCreated: data[dateCreatedKey],
      geoPoint: data[pointKey][geoPointKey],
      imageUrl: data[imageUrlKey],
      locationId: data[locationIdKey],
    );
  }
}
