import 'package:json_annotation/json_annotation.dart';

part 'genExternalLinksParams.g.dart';

@JsonSerializable()
class GenExternalLinksParams extends _GenExternalLinksParams {
  static GenExternalLinksParams fromJson(Map<String, dynamic> json) =>
      _$GenExternalLinksParamsFromJson(json);
  Map<String, dynamic> toJson() => _$GenExternalLinksParamsToJson(this);
}

class _GenExternalLinksParams {
  String? data;
  String? hash;
  String? type;
  bool? withShort;
}
