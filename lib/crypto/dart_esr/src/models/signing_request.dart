// ignore_for_file: unnecessary_this, prefer_final_locals

import 'dart:typed_data';
import 'package:json_annotation/json_annotation.dart';
import 'package:seeds/crypto/dart_esr/dart_esr.dart';
import 'package:seeds/crypto/eosdart/eosdart.dart' as eos;

part 'signing_request.g.dart';

@JsonSerializable(explicitToJson: true)
class SigningRequest {
  @JsonKey(name: 'chain_id')
  List<dynamic>? chainId = [];

  @JsonKey(name: 'req')
  List<dynamic>? req = [];

  @JsonKey(name: 'flags')
  int flags = 1;

  @JsonKey(name: 'callback')
  String? callback = '';

  @JsonKey(name: 'info')
  List<InfoPair> info = [];

  SigningRequest();

  factory SigningRequest.fromJson(Map<String, dynamic> json) => _$SigningRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SigningRequestToJson(this);

  @override
  String toString() => this.toJson().toString();

  Uint8List toBinary(eos.Type type) {
    var buffer = eos.SerialBuffer(Uint8List(0));
    type.serialize!(type, buffer, toJson());
    return buffer.asUint8List();
  }

  factory SigningRequest.fromBinary(eos.Type type, dynamic data) {
    eos.SerialBuffer buffer;
    if (data is eos.SerialBuffer) {
      buffer = data;
    } else if (data is Uint8List) {
      buffer = eos.SerialBuffer(data);
    } else {
      throw 'Data must be either Uint8List or SerialBuffer';
    }
    var deserializedData = Map<String, dynamic>.from(type.deserialize!(type, buffer) as Map);
    return SigningRequest.fromJson(deserializedData);
  }
}
