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
      creatorAccount: data[creatorAccountKey],
      dateCreated: data[dateCreatedKey],
      geoPoint: data[pointKey][geoPointKey],
      imageUrl: data[imageUrlKey],
    );
  }

  factory FirebaseRegion.fromQueryDocumentSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> region) {
    return FirebaseRegion(
      id: region.id,
      creatorAccount: region[creatorAccountKey],
      dateCreated: region[dateCreatedKey],
      geoPoint: region[pointKey][geoPointKey],
      imageUrl: region[imageUrlKey],
    );
  }
}
