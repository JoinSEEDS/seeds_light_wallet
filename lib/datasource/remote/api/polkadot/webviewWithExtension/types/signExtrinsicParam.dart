import 'package:json_annotation/json_annotation.dart';

part 'signExtrinsicParam.g.dart';

@JsonSerializable(explicitToJson: true)
class SignAsExtensionParam extends _SignAsExtensionParam {
  static SignAsExtensionParam fromJson(Map<String, dynamic> json) =>
      _$SignAsExtensionParamFromJson(json);
  Map<String, dynamic> toJson() => _$SignAsExtensionParamToJson(this);
}

abstract class _SignAsExtensionParam {
  String? id;
  String? url;
  String? msgType;
  Map? request;
}

@JsonSerializable()
class SignExtrinsicRequest extends _SignExtrinsicRequest {
  static SignExtrinsicRequest fromJson(Map<String, dynamic> json) =>
      _$SignExtrinsicRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SignExtrinsicRequestToJson(this);
}

abstract class _SignExtrinsicRequest {
  String? address;
  String? blockHash;
  String? blockNumber;
  String? era;
  String? genesisHash;
  String? method;
  String? nonce;
  List<String>? signedExtensions;
  String? specVersion;
  String? tip;
  String? transactionVersion;
  int? version;
  Map? payload;
}

@JsonSerializable()
class SignBytesRequest extends _SignBytesRequest {
  static SignBytesRequest fromJson(Map<String, dynamic> json) =>
      _$SignBytesRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SignBytesRequestToJson(this);
}

abstract class _SignBytesRequest {
  String? address;
  String? data;
  String? type;
}

@JsonSerializable()
class ExtensionSignResult extends _ExtensionSignResult {
  static ExtensionSignResult fromJson(Map<String, dynamic> json) =>
      _$ExtensionSignResultFromJson(json);
  Map<String, dynamic> toJson() => _$ExtensionSignResultToJson(this);
}

abstract class _ExtensionSignResult {
  String? id;
  String? signature;
}
