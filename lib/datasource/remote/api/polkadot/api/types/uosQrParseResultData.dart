import 'package:json_annotation/json_annotation.dart';

part 'uosQrParseResultData.g.dart';

@JsonSerializable()
class UosQrParseResultData extends _UosQrParseResultData {
  static UosQrParseResultData fromJson(Map<String, dynamic> json) =>
      _$UosQrParseResultDataFromJson(json);
  Map<String, dynamic> toJson() => _$UosQrParseResultDataToJson(this);
}

abstract class _UosQrParseResultData {
  String? error;
  String? signer;
  String? genesisHash;
}
