import 'package:json_annotation/json_annotation.dart';

part 'addressIconData.g.dart';

@JsonSerializable()
class AddressIconDataWithMnemonic extends _AddressIconDataWithMnemonic {
  static AddressIconDataWithMnemonic fromJson(Map<String, dynamic> json) =>
      _$AddressIconDataWithMnemonicFromJson(json);
  Map<String, dynamic> toJson() => _$AddressIconDataWithMnemonicToJson(this);
}

abstract class _AddressIconDataWithMnemonic {
  String? mnemonic;
  String? address;
  String? svg;
}

@JsonSerializable()
class AddressIconData extends _AddressIconData {
  static AddressIconData fromJson(Map<String, dynamic> json) =>
      _$AddressIconDataFromJson(json);
  Map<String, dynamic> toJson() => _$AddressIconDataToJson(this);
}

abstract class _AddressIconData {
  String? address;
  String? svg;
}
