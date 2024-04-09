// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'primary_wrapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountNames _$AccountNamesFromJson(Map<String, dynamic> json) => AccountNames()
  ..accountNames = (json['account_names'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList();

Map<String, dynamic> _$AccountNamesToJson(AccountNames instance) =>
    <String, dynamic>{
      'account_names': instance.accountNames,
    };

RequiredKeys _$RequiredKeysFromJson(Map<String, dynamic> json) => RequiredKeys()
  ..requiredKeys = (json['required_keys'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList();

Map<String, dynamic> _$RequiredKeysToJson(RequiredKeys instance) =>
    <String, dynamic>{
      'required_keys': instance.requiredKeys,
    };
