// ignore_for_file: unnecessary_this

import 'package:json_annotation/json_annotation.dart';

part 'info_pair.g.dart';

@JsonSerializable()
class InfoPair {
  @JsonKey(name: 'actor')
  String? key;

  @JsonKey(name: 'permission')
  String? value;

  InfoPair();

  factory InfoPair.fromJson(Map<String, dynamic> json) =>
      _$InfoPairFromJson(json);

  Map<String, dynamic> toJson() => _$InfoPairToJson(this);

  @override
  String toString() => this.toJson().toString();
}
