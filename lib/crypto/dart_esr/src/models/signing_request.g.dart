// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signing_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SigningRequest _$SigningRequestFromJson(Map<String, dynamic> json) =>
    SigningRequest()
      ..chainId = json['chain_id'] as List<dynamic>?
      ..req = json['req'] as List<dynamic>?
      ..flags = (json['flags'] as num).toInt()
      ..callback = json['callback'] as String?
      ..info = (json['info'] as List<dynamic>)
          .map((e) => InfoPair.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$SigningRequestToJson(SigningRequest instance) =>
    <String, dynamic>{
      'chain_id': instance.chainId,
      'req': instance.req,
      'flags': instance.flags,
      'callback': instance.callback,
      'info': instance.info.map((e) => e.toJson()).toList(),
    };
