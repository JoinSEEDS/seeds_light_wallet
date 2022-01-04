// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AbiResp _$AbiRespFromJson(Map<String, dynamic> json) {
  return AbiResp()
    ..accountName = json['account_name'] as String?
    ..codeHash = json['code_hash'] as String?
    ..abiHash = json['abi_hash'] as String?
    ..wasm = json['wasm'] as String?
    ..abi = json['abi'] == null ? null : AbiResp._decodeAbi(json['abi']);
}

Map<String, dynamic> _$AbiRespToJson(AbiResp instance) => <String, dynamic>{
      'account_name': instance.accountName,
      'code_hash': instance.codeHash,
      'abi_hash': instance.abiHash,
      'wasm': instance.wasm,
      'abi': instance.abi
    };

AbiType _$AbiTypeFromJson(Map<String, dynamic> json) {
  return AbiType(json['new_type_name'] as String?, json['type'] as String?);
}

Map<String, dynamic> _$AbiTypeToJson(AbiType instance) =>
    <String, dynamic>{'new_type_name': instance.new_type_name, 'type': instance.type};

AbiStructField _$AbiStructFieldFromJson(Map<String, dynamic> json) {
  return AbiStructField(json['name'] as String?, json['type'] as String?);
}

Map<String, dynamic> _$AbiStructFieldToJson(AbiStructField instance) =>
    <String, dynamic>{'name': instance.name, 'type': instance.type};

AbiStruct _$AbiStructFromJson(Map<String, dynamic> json) {
  return AbiStruct(
      json['name'] as String?,
      json['base'] as String?,
      (json['fields'] as List?)
          ?.map((e) => e == null ? null : AbiStructField.fromJson(e as Map<String, dynamic>))
          .toList());
}

Map<String, dynamic> _$AbiStructToJson(AbiStruct instance) =>
    <String, dynamic>{'name': instance.name, 'base': instance.base, 'fields': instance.fields};

AbiAction _$AbiActionFromJson(Map<String, dynamic> json) {
  return AbiAction(json['name'] as String?, json['type'] as String?, json['ricardian_contract'] as String?);
}

Map<String, dynamic> _$AbiActionToJson(AbiAction instance) =>
    <String, dynamic>{'name': instance.name, 'type': instance.type, 'ricardian_contract': instance.ricardian_contract};

AbiTable _$AbiTableFromJson(Map<String, dynamic> json) {
  return AbiTable(
      json['name'] as String?,
      json['type'] as String?,
      json['index_type'] as String?,
      (json['key_names'] as List?)?.map((e) => e as String).toList(),
      (json['key_types'] as List?)?.map((e) => e as String).toList());
}

Map<String, dynamic> _$AbiTableToJson(AbiTable instance) => <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'index_type': instance.index_type,
      'key_names': instance.key_names,
      'key_types': instance.key_types
    };

AbiRicardianClauses _$AbiRicardianClausesFromJson(Map<String, dynamic> json) {
  return AbiRicardianClauses(json['id'] as String?, json['body'] as String?);
}

Map<String, dynamic> _$AbiRicardianClausesToJson(AbiRicardianClauses instance) =>
    <String, dynamic>{'id': instance.id, 'body': instance.body};

AbiErrorMessages _$AbiErrorMessagesFromJson(Map<String, dynamic> json) {
  return AbiErrorMessages(json['error_code'] as String?, json['error_msg'] as String?);
}

Map<String, dynamic> _$AbiErrorMessagesToJson(AbiErrorMessages instance) =>
    <String, dynamic>{'error_code': instance.error_code, 'error_msg': instance.error_msg};

AbiExtensions _$AbiExtensionsFromJson(Map<String, dynamic> json) {
  return AbiExtensions(json['tag'] as int?, json['value'] as String?);
}

Map<String, dynamic> _$AbiExtensionsToJson(AbiExtensions instance) =>
    <String, dynamic>{'tag': instance.tag, 'value': instance.value};

AbiVariants _$AbiVariantsFromJson(Map<String, dynamic> json) {
  return AbiVariants(json['name'] as String?, (json['types'] as List?)?.map((e) => e as String).toList());
}

Map<String, dynamic> _$AbiVariantsToJson(AbiVariants instance) =>
    <String, dynamic>{'name': instance.name, 'types': instance.types};

Abi _$AbiFromJson(Map<String, dynamic> json) {
  return Abi(
      abi_extensions: (json['abi_extensions'] as List?)
          ?.map((e) => e == null ? null : AbiExtensions.fromJson(e as Map<String, dynamic>))
          .toList(),
      actions: (json['actions'] as List?)
          ?.map((e) => e == null ? null : AbiAction.fromJson(e as Map<String, dynamic>))
          .toList(),
      error_messages: (json['error_messages'] as List?)
          ?.map((e) => e == null ? null : AbiErrorMessages.fromJson(e as Map<String, dynamic>))
          .toList(),
      ricardian_clauses: (json['ricardian_clauses'] as List?)
          ?.map((e) => e == null ? null : AbiRicardianClauses.fromJson(e as Map<String, dynamic>))
          .toList(),
      structs: (json['structs'] as List?)
          ?.map((e) => e == null ? null : AbiStruct.fromJson(e as Map<String, dynamic>))
          .toList(),
      tables: (json['tables'] as List?)
          ?.map((e) => e == null ? null : AbiTable.fromJson(e as Map<String, dynamic>))
          .toList(),
      types:
          (json['types'] as List?)?.map((e) => e == null ? null : AbiType.fromJson(e as Map<String, dynamic>)).toList(),
      variants: (json['variants'] as List?)
          ?.map((e) => e == null ? null : AbiVariants.fromJson(e as Map<String, dynamic>))
          .toList(),
      version: json['version'] as String?);
}

Map<String, dynamic> _$AbiToJson(Abi instance) => <String, dynamic>{
      'version': instance.version,
      'types': instance.types,
      'structs': instance.structs,
      'actions': instance.actions,
      'tables': instance.tables,
      'ricardian_clauses': instance.ricardian_clauses,
      'error_messages': instance.error_messages,
      'abi_extensions': instance.abi_extensions,
      'variants': instance.variants
    };
