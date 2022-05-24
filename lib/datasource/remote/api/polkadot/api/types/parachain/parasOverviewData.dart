import 'package:json_annotation/json_annotation.dart';

part 'parasOverviewData.g.dart';

@JsonSerializable(explicitToJson: true)
class ParasOverviewData extends _ParasOverviewData {
  static ParasOverviewData fromJson(Map json) =>
      _$ParasOverviewDataFromJson(json as Map<String, dynamic>);
  Map toJson() => _$ParasOverviewDataToJson(this);
}

abstract class _ParasOverviewData {
  int parasCount = 0;
  int currentLease = 0;
  int leaseLength = 0;
  int leaseProgress = 0;
}
