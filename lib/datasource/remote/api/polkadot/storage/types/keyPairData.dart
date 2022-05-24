import 'package:json_annotation/json_annotation.dart';

part 'keyPairData.g.dart';

@JsonSerializable()
class KeyPairData extends _KeyPairData {
  static KeyPairData fromJson(Map<String, dynamic> json) => _$KeyPairDataFromJson(json);
  Map<String, dynamic> toJson() => _$KeyPairDataToJson(this);
}

abstract class _KeyPairData {
  String? name;
  String? address;
  String? encoded;
  String? pubKey;

  Map<String, dynamic>? encoding = <String, dynamic>{};
  Map<String, dynamic>? meta = <String, dynamic>{};

  String? memo;
  bool? observation = false;

  /// address avatar in svg format
  String? icon;

  /// indexInfo
  Map? indexInfo;
}

@JsonSerializable()
class SeedBackupData extends _SeedBackupData {
  static SeedBackupData fromJson(Map<String, dynamic> json) => _$SeedBackupDataFromJson(json);
  Map<String, dynamic> toJson() => _$SeedBackupDataToJson(this);
}

abstract class _SeedBackupData {
  String? type;
  String? seed;
  String? error;
}
