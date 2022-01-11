// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'primary_wrapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountNames _$AccountNamesFromJson(Map<String, dynamic> json) {
  return AccountNames()..accountNames = (json['account_names'] as List?)?.map((e) => e as String).toList();
}

Map<String, dynamic> _$AccountNamesToJson(AccountNames instance) =>
    <String, dynamic>{'account_names': instance.accountNames};

RequiredKeys _$RequiredKeysFromJson(Map<String, dynamic> json) {
  return RequiredKeys()..requiredKeys = (json['required_keys'] as List?)?.map((e) => e as String).toList();
}

Map<String, dynamic> _$RequiredKeysToJson(RequiredKeys instance) =>
    <String, dynamic>{'required_keys': instance.requiredKeys};
