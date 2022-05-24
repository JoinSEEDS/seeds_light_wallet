import 'package:json_annotation/json_annotation.dart';

part 'verifyResult.g.dart';

@JsonSerializable()
class VerifyResult extends _VerifyResult {
  static VerifyResult fromJson(Map<String, dynamic> json) =>
      _$VerifyResultFromJson(json);
  Map<String, dynamic> toJson() => _$VerifyResultToJson(this);
}

abstract class _VerifyResult {
  String? crypto;
  bool? isValid;
}
