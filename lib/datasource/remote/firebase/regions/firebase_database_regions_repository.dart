import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_repository.dart';

// Location Keys
const _regionIdKey = "regionId";

// Region Keys
const _nameKey = "name";
const _descriptionKey = "description";
const _creatorIdKey = "creatorId";
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
    required String creatorId,
    required double lat,
    required double long,
    required String imageUrl,
  }) {
    final GeoFirePoint regionLocation = _geo.point(latitude: lat, longitude: long);

    final DocumentReference<Object?> locationRef = locationCollection.doc();
    final DocumentReference<Object?> regionRef = regionCollection.doc();

    final batch = FirebaseFirestore.instance.batch();

    batch.set(
        locationRef,
        {
          _regionIdKey: regionRef.id,
          _pointKey: regionLocation.data,
          _dateCreatedKey: FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true));

    batch.set(
        regionRef,
        {
          _creatorIdKey: creatorId,
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
    required String regionId,
  }) {
    return regionCollection.doc(regionId).update(
      {
        _imageUrlKey: imageUrl,
        _dateUpdatedKey: FieldValue.serverTimestamp(),
      },
    );
  }
}
