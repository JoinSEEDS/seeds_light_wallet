import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeds/datasource/remote/firebase/regions/firebase_database_regions_repository.dart';

class FirebaseRegion {
  final String id;
  final String creatorAccount;
  final Timestamp dateCreated;
  final GeoPoint geoPoint;
  final String imageUrl;

  const FirebaseRegion({
    required this.id,
    required this.creatorAccount,
    required this.dateCreated,
    required this.geoPoint,
    required this.imageUrl,
  });

  factory FirebaseRegion.fromDocumentSnapshot(DocumentSnapshot document) {
    final Map data = document.data()! as Map<String, dynamic>;
    return FirebaseRegion(
      id: document.id,
      creatorAccount: data[creatorAccountKey] as String,
      dateCreated: data[dateCreatedKey] as Timestamp,
      geoPoint: data[pointKey][geoPointKey] as GeoPoint,
      imageUrl: data[imageUrlKey] as String,
    );
  }

  factory FirebaseRegion.fromQueryDocumentSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> region) {
    return FirebaseRegion(
      id: region.id,
      creatorAccount: region[creatorAccountKey] as String,
      dateCreated: region[dateCreatedKey] as Timestamp,
      geoPoint: region[pointKey][geoPointKey] as GeoPoint,
      imageUrl: region[imageUrlKey] as String,
    );
  }
}
