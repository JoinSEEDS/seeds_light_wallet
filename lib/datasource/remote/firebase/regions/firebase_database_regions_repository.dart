import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_repository.dart';

// Location Keys
const _regionAccountKey = "regionAccount";

// Region Keys
const _creatorAccountKey = "creatorAccount";
const _locationIdKey = "locationId";
const _imageUrlKey = "imageUrl";
const _dateCreatedKey = "dateCreated";
const _dateUpdatedKey = "dateUpdated";
const _pointKey = "point";

class FirebaseDatabaseRegionsRepository extends FirebaseDatabaseService {
  // Init firestore and geoFlutterFire
  final _geo = Geoflutterfire();

  /// Create a region
  Future<void> createRegion({
    required String regionAccount,
    required String creatorAccount,
    required double lat,
    required double long,
    required String imageUrl,
  }) {
    final GeoFirePoint regionLocation = _geo.point(latitude: lat, longitude: long);

    final DocumentReference<Object?> locationRef = locationCollection.doc();
    final DocumentReference<Object?> regionRef = regionCollection.doc(regionAccount);

    final batch = FirebaseFirestore.instance.batch();

    /// Location Data
    batch.set(
        locationRef,
        {
          _regionAccountKey: regionAccount,
          _pointKey: regionLocation.data,
          _dateCreatedKey: FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true));

    /// Region Data
    batch.set(
        regionRef,
        {
          _creatorAccountKey: creatorAccount,
          _imageUrlKey: imageUrl,
          _dateCreatedKey: FieldValue.serverTimestamp(),
          _locationIdKey: locationRef.id,
          _pointKey: regionLocation.data,
        },
        SetOptions(merge: true));

    return batch.commit();
  }

  /// Update a region's Image
  Future<void> editRegionImage({
    required String imageUrl,
    required String regionAccount,
  }) {
    return regionCollection.doc(regionAccount).update(
      {
        _imageUrlKey: imageUrl,
        _dateUpdatedKey: FieldValue.serverTimestamp(),
      },
    );
  }
}
