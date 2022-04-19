import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_repository.dart';
import 'package:seeds/datasource/remote/firebase/regions/firebase_database_regions_repository.dart';

class RegionEventModel {
  final String regionAccount;
  final String creatorAccount;
  final String eventName;
  final String eventDescription;
  final GeoPoint eventLocation;
  final String eventImage;
  final DateTime eventStartTime;
  final DateTime eventEndTime;
  final Timestamp createdTime;
  final List<String> users;

  RegionEventModel({
    required this.regionAccount,
    required this.creatorAccount,
    required this.eventName,
    required this.eventDescription,
    required this.eventLocation,
    required this.eventImage,
    required this.eventStartTime,
    required this.eventEndTime,
    required this.users,
    required this.createdTime,
  });

  factory RegionEventModel.mapToRegionEventModel(QueryDocumentSnapshot<Map<String, dynamic>> event) {
    final users = List<String>.from(event.getOrDefault(eventUsersKey, []));
    return RegionEventModel(
      regionAccount: event[regionAccountKey],
      creatorAccount: event[creatorAccountKey],
      eventName: event[eventNameKey],
      eventDescription: event[eventDescriptionKey],
      eventLocation: event[eventLocationKey][geoPointKey],
      eventImage: event[eventImageKey],
      eventStartTime: event[eventStartTimeKey],
      eventEndTime: event[eventEndTimeKey],
      createdTime: event[dateCreatedKey],
      users: users,
    );
  }
}
