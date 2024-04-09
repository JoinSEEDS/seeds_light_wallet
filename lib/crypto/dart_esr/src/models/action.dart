import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
import 'package:seeds/crypto/dart_esr/dart_esr.dart';
import 'package:seeds/crypto/eosdart/eosdart.dart' as eos;
part 'action.g.dart';

@JsonSerializable(explicitToJson: true)
class Action {
  @JsonKey(name: 'account')
  String? account;

  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'authorization', readValue: mapAuthorizations)
  List<Authorization?>? authorization;

  @JsonKey(name: 'data')
  Object? data;

//  @JsonKey(name: 'hex_data')
//  String hexData;


  Action();

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);

  Map<String, dynamic> toJson() => _$ActionToJson(this);

  @override
  String toString() => toJson().toString();

  Uint8List toBinary(eos.Type type) {
    final buffer = eos.SerialBuffer(Uint8List(0));
    type.serialize!(type, buffer, toJson());
    return buffer.asUint8List();
  }

  factory Action.fromBinary(eos.Type type, dynamic data) {
    eos.SerialBuffer buffer;
    if (data is eos.SerialBuffer) {
      buffer = data;
    } else if (data is Uint8List) {
      buffer = eos.SerialBuffer(data);
    } else {
      throw 'Data must be either Uint8List or SerialBuffer';
    }
    final deserializedData = Map<String, dynamic>.from(type.deserialize!(type, buffer) as Map);
    return Action.fromJson(deserializedData);
  }
}
  Object? mapAuthorizations(Map<dynamic, dynamic> json, String key) {
    return (json[key] as List<Map>)
        .map((e) =>   Authorization.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
