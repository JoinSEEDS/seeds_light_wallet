// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Identity _$IdentityFromJson(Map<String, dynamic> json) => Identity()
  ..authorization = json['permission'] == null
      ? null
      : Authorization.fromJson(json['permission'] as Map<String, dynamic>)
  ..scope = json['scope'] as String?;

Map<String, dynamic> _$IdentityToJson(Identity instance) => <String, dynamic>{
      'permission': instance.authorization?.toJson(),
      'scope': instance.scope,
    };
