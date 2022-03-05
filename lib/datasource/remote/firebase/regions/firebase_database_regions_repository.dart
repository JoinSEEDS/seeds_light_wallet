import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_location_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

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
  Future<Result<String>> createRegion({
    required String regionAccount,
    required String userAccount,
    required double latitude,
    required double longitude,
    required String imageUrl,
  }) {
    final GeoFirePoint regionLocation = _geo.point(latitude: latitude, longitude: longitude);

    final DocumentReference<Object?> locationRef = locationCollection.doc(regionAccount);
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
          _creatorAccountKey: userAccount,
          _imageUrlKey: imageUrl,
          _dateCreatedKey: FieldValue.serverTimestamp(),
          _locationIdKey: regionAccount,
          _pointKey: regionLocation.data,
        },
        SetOptions(merge: true));

    return batch
        .commit()
        .then((value) => mapFirebaseResponse<String>(() {
              return regionAccount;
            }))
        .onError((error, stackTrace) => mapFirebaseError(stackTrace));
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

  /// Delete a region and its matching location
  Future<void> deleteRegion(String regionAccount) {
    final batch = FirebaseFirestore.instance.batch();
    batch.delete(regionCollection.doc(regionAccount));
    batch.delete(locationCollection.doc(regionAccount));

    return batch.commit();
  }

  /// This function returns a Stream of the list of DocumentSnapshot data,
  /// plus some useful metadata like distance from the centerpoint.
  Future<List<RegionLocation>> findRegionsByLocation({
    required double latitude,
    required double longitude,
    required double radius,
  }) {
    // Create a geoFirePoint
    final GeoFirePoint center = _geo.point(latitude: latitude, longitude: longitude);
    return _geo
        .collection(collectionRef: locationCollection)
        .within(center: center, radius: radius, field: _pointKey)
        .asyncMap((List<DocumentSnapshot> event) => event
            // ignore: cast_nullable_to_non_nullable
            .map((DocumentSnapshot document) => RegionLocation.fromMap(document.data() as Map<String, dynamic>))
            .toList())
        .single;
  }
}
