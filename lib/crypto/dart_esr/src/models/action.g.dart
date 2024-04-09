// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Action _$ActionFromJson(Map<String, dynamic> json) => Action()
  ..account = json['account'] as String?
  ..name = json['name'] as String?
  ..authorization = (mapAuthorizations(json, 'authorization') as List<dynamic>?)
      ?.map((e) =>
          e == null ? null : Authorization.fromJson(e as Map<String, dynamic>))
      .toList()
  ..data = json['data'];

Map<String, dynamic> _$ActionToJson(Action instance) => <String, dynamic>{
      'account': instance.account,
      'name': instance.name,
      'authorization': instance.authorization?.map((e) => e?.toJson()).toList(),
      'data': instance.data,
    };
