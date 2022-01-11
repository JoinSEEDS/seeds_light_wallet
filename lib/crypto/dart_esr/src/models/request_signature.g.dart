// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_signature.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestSignature _$RequestSignatureFromJson(Map<String, dynamic> json) {
  return RequestSignature()
    ..signer = json['signer'] as String
    ..signature = json['signature'] as String;
}

Map<String, dynamic> _$RequestSignatureToJson(RequestSignature instance) {
  return <String, dynamic>{
    'signer': instance.signer,
    'signature': instance.signature,
  };
}
