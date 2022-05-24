import 'package:json_annotation/json_annotation.dart';

part 'networkParams.g.dart';

@JsonSerializable()
class NetworkParams extends _NetworkParams {
  static NetworkParams fromJson(Map<String, dynamic> json) =>
      _$NetworkParamsFromJson(json);
  Map<String, dynamic> toJson() => _$NetworkParamsToJson(this);
}

abstract class _NetworkParams {
  String? name = '';
  String? endpoint = '';
  int? ss58 = 0;
}
