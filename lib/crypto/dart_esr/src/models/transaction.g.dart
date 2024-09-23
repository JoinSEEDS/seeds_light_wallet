// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction()
  ..expiration = json['expiration'] == null
      ? null
      : DateTime.parse(json['expiration'] as String)
  ..refBlockNum = (json['ref_block_num'] as num?)?.toInt()
  ..refBlockPrefix = (json['ref_block_prefix'] as num?)?.toInt()
  ..maxNetUsageWords = (json['max_net_usage_words'] as num?)?.toInt()
  ..maxCpuUsageMs = (json['max_cpu_usage_ms'] as num?)?.toInt()
  ..delaySec = (json['delay_sec'] as num?)?.toInt()
  ..contextFreeActions = json['context_free_actions'] as List<dynamic>?
  ..actions = (json['actions'] as List<dynamic>?)
      ?.map(
          (e) => e == null ? null : Action.fromJson(e as Map<String, dynamic>))
      .toList()
  ..transactionExtensions = json['transaction_extensions'] as List<dynamic>?
  ..signatures =
      (json['signatures'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..contextFreeData = json['context_free_data'] as List<dynamic>?;

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'expiration': instance.expiration?.toIso8601String(),
      'ref_block_num': instance.refBlockNum,
      'ref_block_prefix': instance.refBlockPrefix,
      'max_net_usage_words': instance.maxNetUsageWords,
      'max_cpu_usage_ms': instance.maxCpuUsageMs,
      'delay_sec': instance.delaySec,
      'context_free_actions': instance.contextFreeActions,
      'actions': instance.actions?.map((e) => e?.toJson()).toList(),
      'transaction_extensions': instance.transactionExtensions,
      'signatures': instance.signatures,
      'context_free_data': instance.contextFreeData,
    };
