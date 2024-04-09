// ignore_for_file: always_use_package_imports, cast_nullable_to_non_nullable, prefer_final_locals, unnecessary_this, non_constant_identifier_names

import 'dart:convert';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

import '../eosdart_base.dart';
import '../jsons.dart';
import '../numeric.dart';
import '../serialize.dart' as ser;
import './conversion_helper.dart';

part 'abi.g.dart';

@JsonSerializable()
class AbiResp with ConversionHelper {
  @JsonKey(name: 'account_name')
  String? accountName;

  @JsonKey(name: 'code_hash')
  String? codeHash;

  @JsonKey(name: 'abi_hash')
  String? abiHash;

  @JsonKey(name: 'wasm')
  String? wasm;

  @JsonKey(name: 'abi', fromJson: _decodeAbi)
  Abi? abi;

  AbiResp();

  factory AbiResp.fromJson(Map<String, dynamic> json) =>
      _$AbiRespFromJson(json);

  Map<String, dynamic> toJson() => _$AbiRespToJson(this);

  static Abi? _decodeAbi(Object? abi) {
    if (abi is String) {
      return _base64ToAbi(abi);
    }
    return Abi.fromJson(abi as Map<String, dynamic>);
  }

  static Abi? _base64ToAbi(String base64String) {
    Uint8List abiBuffer = base64ToBinary(base64String);

    return _rawAbiToJson(abiBuffer);
  }

  /// Decodes an abi as Uint8List into json. */
  static Abi? _rawAbiToJson(Uint8List rawAbi) {
    Map<String?, Type> abiTypes = ser.getTypesFromAbi(
        ser.createInitialTypes(), Abi.fromJson(json.decode(abiJson) as Map<String, dynamic>));
    try {
      var buffer = ser.SerialBuffer(rawAbi);
      var str = buffer.getString();
      if (!ser.supportedAbiVersion(str)) {
        throw 'Unsupported abi version';
      }
      buffer.restartRead();
      var t = abiTypes['abi_def']!;
      var b = t.deserialize!(t, buffer);
      return Abi.fromJson(json.decode(json.encode(b)) as Map<String, dynamic>);
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class AbiType {
  @JsonKey(name: 'new_type_name')
  String? new_type_name; //new_type_name

  @JsonKey(name: 'type')
  String? type;

  AbiType(this.new_type_name, this.type);

  factory AbiType.fromJson(Map<String, dynamic> json) =>
      _$AbiTypeFromJson(json);

  Map<String, dynamic> toJson() => _$AbiTypeToJson(this);

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class AbiStructField {
  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'type')
  String? type;

  AbiStructField(this.name, this.type);

  factory AbiStructField.fromJson(Map<String, dynamic> json) =>
      _$AbiStructFieldFromJson(json);

  Map<String, dynamic> toJson() => _$AbiStructFieldToJson(this);

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class AbiStruct {
  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'base')
  String? base;

  @JsonKey(name: 'fields')
  List<AbiStructField?>? fields;

  AbiStruct(this.name, this.base, this.fields);

  factory AbiStruct.fromJson(Map<String, dynamic> json) =>
      _$AbiStructFromJson(json);

  Map<String, dynamic> toJson() => _$AbiStructToJson(this);

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class AbiAction {
  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'type')
  String? type;

  @JsonKey(name: 'ricardian_contract')
  String? ricardian_contract; //ricardian_contract

  AbiAction(this.name, this.type, this.ricardian_contract);

  factory AbiAction.fromJson(Map<String, dynamic> json) =>
      _$AbiActionFromJson(json);

  Map<String, dynamic> toJson() => _$AbiActionToJson(this);

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class AbiTable {
  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'type')
  String? type;

  @JsonKey(name: 'index_type')
  String? index_type; //index_type

  @JsonKey(name: 'key_names')
  List<String>? key_names; //key_names

  @JsonKey(name: 'key_types')
  List<String>? key_types; //key_types

  AbiTable(
      this.name, this.type, this.index_type, this.key_names, this.key_types);

  factory AbiTable.fromJson(Map<String, dynamic> json) =>
      _$AbiTableFromJson(json);

  Map<String, dynamic> toJson() => _$AbiTableToJson(this);

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class AbiRicardianClauses {
  @JsonKey(name: 'id')
  String? id;

  @JsonKey(name: 'body')
  String? body;

  AbiRicardianClauses(this.id, this.body);

  factory AbiRicardianClauses.fromJson(Map<String, dynamic> json) =>
      _$AbiRicardianClausesFromJson(json);

  Map<String, dynamic> toJson() => _$AbiRicardianClausesToJson(this);

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class AbiErrorMessages {
  @JsonKey(name: 'error_code')
  String? error_code;

  @JsonKey(name: 'error_msg')
  String? error_msg;

  AbiErrorMessages(this.error_code, this.error_msg);

  factory AbiErrorMessages.fromJson(Map<String, dynamic> json) =>
      _$AbiErrorMessagesFromJson(json);

  Map<String, dynamic> toJson() => _$AbiErrorMessagesToJson(this);

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class AbiExtensions {
  @JsonKey(name: 'tag')
  int? tag;

  @JsonKey(name: 'value')
  String? value;

  AbiExtensions(this.tag, this.value);

  factory AbiExtensions.fromJson(Map<String, dynamic> json) =>
      _$AbiExtensionsFromJson(json);

  Map<String, dynamic> toJson() => _$AbiExtensionsToJson(this);

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class AbiVariants {
  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'types')
  List<String>? types;

  AbiVariants(this.name, this.types);

  factory AbiVariants.fromJson(Map<String, dynamic> json) =>
      _$AbiVariantsFromJson(json);

  Map<String, dynamic> toJson() => _$AbiVariantsToJson(this);

  @override
  String toString() => this.toJson().toString();
}

/// Structured format for abis
@JsonSerializable()
class Abi {
  @JsonKey(name: 'version')
  String? version;

  @JsonKey(name: 'types')
  List<AbiType?>? types;

  @JsonKey(name: 'structs')
  List<AbiStruct?>? structs;

  @JsonKey(name: 'actions')
  List<AbiAction?>? actions;

  @JsonKey(name: 'tables')
  List<AbiTable?>? tables;

  @JsonKey(name: 'ricardian_clauses')
  List<AbiRicardianClauses?>? ricardian_clauses;

  @JsonKey(name: 'error_messages')
  List<AbiErrorMessages?>? error_messages;

  @JsonKey(name: 'abi_extensions')
  List<AbiExtensions?>? abi_extensions;

  @JsonKey(name: 'variants')
  List<AbiVariants?>? variants;

  Abi(
      {this.abi_extensions,
      this.actions,
      this.error_messages,
      this.ricardian_clauses,
      this.structs,
      this.tables,
      this.types,
      this.variants,
      this.version});

  factory Abi.fromJson(Map<String, dynamic> json) => _$AbiFromJson(json);

  Map<String, dynamic> toJson() => _$AbiToJson(this);

  @override
  String toString() => this.toJson().toString();
}
