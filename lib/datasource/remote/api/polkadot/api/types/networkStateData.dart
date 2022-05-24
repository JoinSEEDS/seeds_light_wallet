import 'package:json_annotation/json_annotation.dart';

part 'networkStateData.g.dart';

@JsonSerializable()
class NetworkStateData extends _NetworkStateData {
  static NetworkStateData fromJson(Map<String, dynamic> json) =>
      _$NetworkStateDataFromJson(json);
  Map<String, dynamic> toJson() => _$NetworkStateDataToJson(this);
}

abstract class _NetworkStateData {
  int? ss58Format = 0;
  List<int>? tokenDecimals = [12];
  List<String>? tokenSymbol;
  String? name = '';
  String? genesisHash = '';
}
