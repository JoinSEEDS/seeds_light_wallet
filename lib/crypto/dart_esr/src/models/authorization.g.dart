// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authorization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Authorization _$AuthorizationFromJson(Map<String, dynamic> json) {
  return Authorization()
    ..actor = json['actor'] as String
    ..permission = json['permission'] as String;
}

Map<String, dynamic> _$AuthorizationToJson(Authorization instance) =>
    <String, dynamic>{
      'actor': instance.actor,
      'permission': instance.permission,
    };
