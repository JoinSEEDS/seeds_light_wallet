import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_event_model.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_location_model.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_message_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

// Location Keys
const regionAccountKey = "regionAccount";

// Region Keys
const creatorAccountKey = "creatorAccount";
const _locationIdKey = "locationId";
const _imageUrlKey = "imageUrl";
const dateCreatedKey = "dateCreated";
const _dateUpdatedKey = "dateUpdated";
const _pointKey = "point";

// Events
const eventNameKey = "eventName";
const eventLocationKey = "eventLocation";
const eventImageKey = "eventImage";
const eventTimeKey = "eventTime";

// messages
const messageTextKey = "messageText";

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
          regionAccountKey: regionAccount,
          _pointKey: regionLocation.data,
          dateCreatedKey: FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true));

    /// Region Data
    batch.set(
        regionRef,
        {
          creatorAccountKey: userAccount,
          _imageUrlKey: imageUrl,
          dateCreatedKey: FieldValue.serverTimestamp(),
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
  }) async {
    // Create a geoFirePoint
    final GeoFirePoint center = _geo.point(latitude: latitude, longitude: longitude);
    return _geo
        .collection(collectionRef: locationCollection)
        .within(center: center, radius: radius, field: _pointKey)
        .asyncMap((List<DocumentSnapshot> event) => event
            // ignore: cast_nullable_to_non_nullable
            .map((DocumentSnapshot document) => RegionLocation.fromMap(document.data() as Map<String, dynamic>))
            .toList())
        .firstWhere((i) => true);
  }

  Future<Result<String>> createRegionEvent(
    String eventName,
    String regionAccount,
    String creatorAccount,
    String eventLocation,
    String eventImage,
    DateTime eventTime,
  ) async {
    final data = {
      regionAccountKey: regionAccount,
      eventNameKey: eventName,
      creatorAccountKey: creatorAccount,
      eventLocationKey: eventLocation,
      eventImageKey: eventImage,
      eventTimeKey: eventTime,
      dateCreatedKey: FieldValue.serverTimestamp(),
    };

    return regionEventCollection
        .doc()
        .set(data)
        .then((value) => mapFirebaseResponse<String>(() {
              return eventName;
            }))
        .onError((error, stackTrace) => mapFirebaseError(error));
  }

  Future<Result<String>> editRegionEvent(
    String eventId,
    String? eventName,
    String? eventLocation,
    String? eventImage,
    DateTime? eventTime,
  ) async {
    final data = {};
    if (eventName != null) {
      data.putIfAbsent(eventNameKey, () => eventName);
    }

    if (eventLocation != null) {
      data.putIfAbsent(eventLocationKey, () => eventLocation);
    }

    if (eventImage != null) {
      data.putIfAbsent(eventImageKey, () => eventImage);
    }

    if (eventTime != null) {
      data.putIfAbsent(eventTimeKey, () => eventTime);
    }

    return regionEventCollection
        .doc(eventId)
        .set(data, SetOptions(merge: true))
        .then((value) => mapFirebaseResponse<String>(() {
              return eventName;
            }))
        .onError((error, stackTrace) => mapFirebaseError(error));
  }

  Future<Stream<Iterable<RegionEventModel>>> getEventsForRegion(String regionAccount) async {
    return regionEventCollection.where(regionAccountKey, isEqualTo: regionAccount).snapshots().asyncMap(
        (QuerySnapshot event) =>
            event.docs.map((QueryDocumentSnapshot event) => RegionEventModel.mapToRegionEventModel(event)));
  }

  Future<Result<String>> sendMessageToRegion(String regionAccount, String creatorAccount, String message) {
    final data = {
      regionAccountKey: regionAccount,
      creatorAccountKey: creatorAccount,
      dateCreatedKey: FieldValue.serverTimestamp(),
      messageTextKey: message
    };

    return regionMessageCollection
        .doc()
        .set(data)
        .then((value) => mapFirebaseResponse<String>(() {
              return creatorAccount;
            }))
        .onError((error, stackTrace) => mapFirebaseError(error));
  }

  Stream<List<RegionMessageModel>> getMessagesForRegion(String regionAccount) {
    return regionMessageCollection.where(regionAccountKey, isEqualTo: regionAccount).snapshots().asyncMap(
        (QuerySnapshot event) => event.docs
            .map((QueryDocumentSnapshot event) => RegionMessageModel.mapToRegionMessageModel(event))
            .toList());
  }
}
