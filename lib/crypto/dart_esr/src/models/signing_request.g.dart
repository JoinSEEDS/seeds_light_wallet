// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signing_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SigningRequest _$SigningRequestFromJson(Map<String, dynamic> json) {
  final List info = json['info'];
  final List<esr.InfoPair> infos = info
      .map((e) => (esr.InfoPair()
        ..key = e['key']
        ..value = e['value']))
      .toList();
  return SigningRequest()
    ..chainId = json['chain_id'] as List
    ..req = json['req'] as List
    ..flags = json['flags'] as int
    ..callback = json['callback'] as String
    ..info = infos;
}

Map<String, dynamic> _$SigningRequestToJson(SigningRequest instance) {
  return <String, dynamic>{
    'chain_id': instance.chainId,
    'req': instance.req,
    'flags': instance.flags,
    'callback': instance.callback,
    'info': instance.info.map((e) => e.toJson()).toList(),
  };
}
