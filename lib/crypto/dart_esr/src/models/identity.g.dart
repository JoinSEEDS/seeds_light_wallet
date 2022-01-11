// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Identity _$IdentityFromJson(Map<String, dynamic> json) {
  return Identity()..authorization = Authorization.fromJson(Map<String, dynamic>.from(json['permission']));
}

Map<String, dynamic> _$IdentityToJson(Identity instance) => <String, dynamic>{
      'permission': instance.authorization!.toJson(),
    };
