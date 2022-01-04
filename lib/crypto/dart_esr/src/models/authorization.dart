// ignore_for_file: unnecessary_this

import 'package:json_annotation/json_annotation.dart';

part 'authorization.g.dart';

@JsonSerializable()
class Authorization {
  @JsonKey(name: 'actor')
  String? actor;

  @JsonKey(name: 'permission')
  String? permission;

  Authorization();

  factory Authorization.fromJson(Map<String, dynamic> json) => _$AuthorizationFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorizationToJson(this);

  @override
  String toString() => this.toJson().toString();
}
