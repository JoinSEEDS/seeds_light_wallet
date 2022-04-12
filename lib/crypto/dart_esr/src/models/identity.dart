import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
import 'package:seeds/crypto/dart_esr/dart_esr.dart';
import 'package:seeds/crypto/eosdart/eosdart.dart' as eos;

part 'identity.g.dart';

@JsonSerializable(explicitToJson: true)
class Identity {
  @JsonKey(name: 'permission')
  Authorization? authorization;

  /// Note: scope key only exists in V3 of the specification. V2 and below don't have this key.
  @JsonKey(name: 'scope')
  String? scope;

  Identity();

  factory Identity.fromJson(Map<String, dynamic> json) => _$IdentityFromJson(json);

  Map<String, dynamic> toJson() => _$IdentityToJson(this);

  @override
  String toString() => toJson().toString();

  Uint8List toBinary(eos.Type type) {
    final buffer = eos.SerialBuffer(Uint8List(0));
    type.serialize!(type, buffer, toJson());
    return buffer.asUint8List();
  }

  factory Identity.fromBinary(eos.Type type, dynamic data) {
    eos.SerialBuffer buffer;
    if (data is eos.SerialBuffer) {
      buffer = data;
    } else if (data is Uint8List) {
      buffer = eos.SerialBuffer(data);
    } else {
      throw 'Data must be either Uint8List or SerialBuffer';
    }
    final deserializedData = Map<String, dynamic>.from(type.deserialize!(type, buffer));
    return Identity.fromJson(deserializedData);
  }
}
