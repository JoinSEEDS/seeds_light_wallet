import 'package:json_annotation/json_annotation.dart';

part 'bidData.g.dart';

@JsonSerializable()
class BidData extends _BidData {
  static BidData fromJson(Map json) => _$BidDataFromJson(json as Map<String, dynamic>);
  Map toJson() => _$BidDataToJson(this);
}

abstract class _BidData {
  String? paraId;
  int? firstSlot;
  int? lastSlot;
  bool? isCrowdloan;
  dynamic value;
}
