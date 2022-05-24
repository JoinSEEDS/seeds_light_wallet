import 'package:json_annotation/json_annotation.dart';

part 'pairingData.g.dart';

@JsonSerializable(explicitToJson: true)
class WCPairingData extends _WCPairingData {
  static WCPairingData fromJson(Map json) => _$WCPairingDataFromJson(json as Map<String, dynamic>);
  Map toJson() => _$WCPairingDataToJson(this);
}

abstract class _WCPairingData {
  String? topic;
  Map? relay;
  WCProposerInfo? proposer;
  Map? signal;
  WCPermissionData? permissions;
  int? ttl;
}

@JsonSerializable(explicitToJson: true)
class WCPairedData extends _WCPairedData {
  static WCPairedData fromJson(Map json) => _$WCPairedDataFromJson(json as Map<String, dynamic>);
  Map toJson() => _$WCPairedDataToJson(this);
}

abstract class _WCPairedData {
  String? topic;
  Map? relay;
  WCProposerInfo? peer;
  WCPermissionData? permissions;
  Map? state;
  int? expiry;
}

@JsonSerializable(explicitToJson: true)
class WCProposerInfo extends _WCProposerInfo {
  static WCProposerInfo fromJson(Map json) => _$WCProposerInfoFromJson(json as Map<String, dynamic>);
  Map toJson() => _$WCProposerInfoToJson(this);
}

abstract class _WCProposerInfo {
  String? publicKey;
  WCProposerMeta? metadata;
}

@JsonSerializable()
class WCProposerMeta extends _WCProposerMeta {
  static WCProposerMeta fromJson(Map json) => _$WCProposerMetaFromJson(json as Map<String, dynamic>);
  Map toJson() => _$WCProposerMetaToJson(this);
}

abstract class _WCProposerMeta {
  String? name;
  String? description;
  String? url;
  List<String>? icons;
}

@JsonSerializable()
class WCPermissionData extends _WCPermissionData {
  static WCPermissionData fromJson(Map json) =>
      _$WCPermissionDataFromJson(json as Map<String, dynamic>);
  Map toJson() => _$WCPermissionDataToJson(this);
}

abstract class _WCPermissionData {
  Map? blockchain;
  Map? jsonrpc;
  Map? notifications;
}
