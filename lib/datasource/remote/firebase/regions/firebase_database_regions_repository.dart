import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_repository.dart';
import 'package:seeds/utils/string_extension.dart';

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
    required String title,
    required String description,
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
          _nameKey: title,
          _descriptionKey: description,
          _creatorIdKey: creatorId,
          _imageUrlKey: imageUrl,
          _dateCreatedKey: FieldValue.serverTimestamp(),
          _locationIdKey: locationRef.id,
          _pointKey: regionLocation.data,
        },
        SetOptions(merge: true));

    return batch.commit();
  }

  /// Update a region
  Future<void> editRegion({
    String? name,
    String? description,
    LocationData? locationData,
    String? imageUrl,
    required String regionId,
  }) {
    final batch = FirebaseFirestore.instance.batch();

    final Map<String, dynamic> regionData = {};

    if (!name.isNullOrEmpty) {
      regionData.putIfAbsent(_nameKey, () => name);
    }
    if (!description.isNullOrEmpty) {
      regionData.putIfAbsent(_descriptionKey, () => description);
    }
    if (!imageUrl.isNullOrEmpty) {
      regionData.putIfAbsent(_imageUrlKey, () => imageUrl);
    }

    regionData.putIfAbsent(_dateUpdatedKey, () => FieldValue.serverTimestamp());

    if (locationData != null) {
      final GeoFirePoint regionLocation = _geo.point(latitude: locationData.newLat, longitude: locationData.newLong);
      final DocumentReference<Object?> locationRef = locationCollection.doc(locationData.currentLocationId);
      regionData.putIfAbsent(_pointKey, () => regionLocation.data);

      batch.set(
          locationRef,
          {
            _pointKey: regionLocation.data,
            _dateUpdatedKey: FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true));
    }

    final DocumentReference<Object?> regionRef = regionCollection.doc(regionId);
    batch.set(regionRef, regionData, SetOptions(merge: true));

    return batch.commit();
  }
}

class LocationData {
  final double newLat;
  final double newLong;
  final String currentLocationId;

  LocationData(this.newLat, this.newLong, this.currentLocationId);
}
