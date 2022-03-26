import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeds/datasource/remote/firebase/regions/firebase_database_regions_repository.dart';

class RegionEventModel {
  final String regionAccount;
  final String creatorAccount;
  final String eventName;
  final String eventLocation;
  final String eventImage;
  final DateTime eventTime;

  RegionEventModel({
    required this.regionAccount,
    required this.creatorAccount,
    required this.eventName,
    required this.eventLocation,
    required this.eventImage,
    required this.eventTime,
  });

  factory RegionEventModel.mapToRegionEventModel(QueryDocumentSnapshot event) {
    return RegionEventModel(
        regionAccount: event[regionAccountKey],
        creatorAccount: event[creatorAccountKey],
        eventName: event[eventNameKey],
        eventLocation: event[eventLocationKey],
        eventImage: event[eventImageKey],
        eventTime: event[eventTimeKey]);
  }
}
