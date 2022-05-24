import 'package:json_annotation/json_annotation.dart';

part 'fundData.g.dart';

@JsonSerializable()
class FundData extends _FundData {
  static FundData fromJson(Map json) =>
      _$FundDataFromJson(json as Map<String, dynamic>);
  Map toJson() => _$FundDataToJson(this);
}

abstract class _FundData {
  String paraId = '';
  dynamic cap = '';
  dynamic value = '';
  dynamic end = '';
  int firstSlot = 0;
  int lastSlot = 0;
  bool isWinner = false;
  bool isCapped = false;
  bool isEnded = false;
}
