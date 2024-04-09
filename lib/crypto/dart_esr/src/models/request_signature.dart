import 'dart:typed_data';
import 'package:json_annotation/json_annotation.dart';
import 'package:seeds/crypto/eosdart/eosdart.dart' as eos;

part 'request_signature.g.dart';

@JsonSerializable(explicitToJson: true)
class RequestSignature {
  @JsonKey(name: 'signer')
  String? signer = '';

  @JsonKey(name: 'signature')
  String? signature = '';

  RequestSignature();

  factory RequestSignature.fromJson(Map<String, dynamic> json) => _$RequestSignatureFromJson(json);

  Map<String, dynamic> toJson() => _$RequestSignatureToJson(this);

  @override
  String toString() => toJson().toString();

  Uint8List toBinary(eos.Type type) {
    final buffer = eos.SerialBuffer(Uint8List(0));
    type.serialize!(type, buffer, toJson());
    return buffer.asUint8List();
  }

  factory RequestSignature.fromBinary(eos.Type type, dynamic data) {
    eos.SerialBuffer? buffer;
    if (buffer is eos.SerialBuffer) {
      buffer = data as eos.SerialBuffer;
    } else if (buffer is Uint8List) {
      buffer = eos.SerialBuffer(data as Uint8List);
    } else {
      throw 'Data must be either Uint8List or SerialBuffer';
    }
    final deserializedData = Map<String, dynamic>.from(type.deserialize!(type, buffer) as Map);
    return RequestSignature.fromJson(deserializedData);
  }

  // ignore: prefer_constructors_over_static_methods
  static RequestSignature clone(String? signer, String? signature) {
    return RequestSignature()
      ..signer = signer
      ..signature = signature;
  }
}
