// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Identity _$IdentityFromJson(Map<String, dynamic> json) {
  final perm = json['permission'];
  Authorization? auth;
  print("identity from json: $json  -- perm = $perm = ${perm == null ? "actual NULL" : ""}");
  if (perm != null && perm != "null") {
    auth = Authorization.fromJson(Map<String, dynamic>.from(json['permission']));
  }
  return Identity()
    ..authorization = auth
    ..scope = json['scope'];
}

Map<String, dynamic> _$IdentityToJson(Identity instance) => <String, dynamic>{
      'scope': instance.scope,
      'permission': instance.authorization?.toJson(),
    };
