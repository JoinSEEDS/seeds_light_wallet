import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeds/datasource/remote/firebase/regions/firebase_database_regions_repository.dart';

class RegionMessageModel {
  final String regionAccount;
  final String senderAccount;
  final String message;
  final DateTime createdDate;

  RegionMessageModel({
    required this.regionAccount,
    required this.senderAccount,
    required this.message,
    required this.createdDate,
  });

  factory RegionMessageModel.mapToRegionMessageModel(QueryDocumentSnapshot event) {
    return RegionMessageModel(
        regionAccount: event[regionAccountKey] as String,
        senderAccount: event[creatorAccountKey] as String,
        message: event[messageTextKey] as String,
        createdDate: event[dateCreatedKey] as DateTime);
  }
}
