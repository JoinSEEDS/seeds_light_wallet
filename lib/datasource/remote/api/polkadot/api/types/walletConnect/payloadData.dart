import 'package:json_annotation/json_annotation.dart';

part 'payloadData.g.dart';

@JsonSerializable(explicitToJson: true)
class WCPayloadData extends _WCPayloadData {
  static WCPayloadData fromJson(Map json) => _$WCPayloadDataFromJson(json as Map<String, dynamic>);
  Map toJson() => _$WCPayloadDataToJson(this);
}

abstract class _WCPayloadData {
  String? topic;
  String? chainId;
  WCPayload? payload;
}

@JsonSerializable()
class WCPayload extends _WCPayload {
  static WCPayload fromJson(Map json) => _$WCPayloadFromJson(json as Map<String, dynamic>);
  Map toJson() => _$WCPayloadToJson(this);
}

abstract class _WCPayload {
  int? id;
  String? method;
  List? params;
}
