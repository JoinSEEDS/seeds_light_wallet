// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionBlock _$TransactionBlockFromJson(Map<String, dynamic> json) =>
    TransactionBlock()
      ..id = json['id'] as String?
      ..trx = json['trx'] == null
          ? null
          : TransactionWithReceipt.fromJson(json['trx'] as Map<String, dynamic>)
      ..blockTime = json['block_time'] == null
          ? null
          : DateTime.parse(json['block_time'] as String)
      ..blockNum = ConversionHelper.getIntFromJson(json['block_num'])
      ..lastIrreversibleBlock =
          ConversionHelper.getIntFromJson(json['last_irreversible_block'])
      ..traces = (json['traces'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : ActionWithReceipt.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$TransactionBlockToJson(TransactionBlock instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trx': instance.trx,
      'block_time': instance.blockTime?.toIso8601String(),
      'block_num': instance.blockNum,
      'last_irreversible_block': instance.lastIrreversibleBlock,
      'traces': instance.traces,
    };

TransactionWithReceipt _$TransactionWithReceiptFromJson(
        Map<String, dynamic> json) =>
    TransactionWithReceipt()
      ..receipt = json['receipt'] == null
          ? null
          : TransactionReceipt.fromJson(json['receipt'] as Map<String, dynamic>)
      ..transaction = json['trx'] == null
          ? null
          : Transaction.fromJson(json['trx'] as Map<String, dynamic>);

Map<String, dynamic> _$TransactionWithReceiptToJson(
        TransactionWithReceipt instance) =>
    <String, dynamic>{
      'receipt': instance.receipt,
      'trx': instance.transaction,
    };

TransactionReceipt _$TransactionReceiptFromJson(Map<String, dynamic> json) =>
    TransactionReceipt()
      ..status = json['status'] as String?
      ..cpuUsageUs = ConversionHelper.getIntFromJson(json['cpu_usage_us'])
      ..netUsageWords = ConversionHelper.getIntFromJson(json['net_usage_words'])
      ..trx = json['trx'];

Map<String, dynamic> _$TransactionReceiptToJson(TransactionReceipt instance) =>
    <String, dynamic>{
      'status': instance.status,
      'cpu_usage_us': instance.cpuUsageUs,
      'net_usage_words': instance.netUsageWords,
      'trx': instance.trx,
    };

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

TransactionCommitted _$TransactionCommittedFromJson(
        Map<String, dynamic> json) =>
    TransactionCommitted()
      ..id = json['transaction_id'] as String?
      ..processed = json['processed'] == null
          ? null
          : TransactionProcessed.fromJson(
              json['processed'] as Map<String, dynamic>);

Map<String, dynamic> _$TransactionCommittedToJson(
        TransactionCommitted instance) =>
    <String, dynamic>{
      'transaction_id': instance.id,
      'processed': instance.processed,
    };

TransactionProcessed _$TransactionProcessedFromJson(
        Map<String, dynamic> json) =>
    TransactionProcessed()
      ..id = json['id'] as String?
      ..blockNum = ConversionHelper.getIntFromJson(json['block_num'])
      ..blockTime = json['block_time'] == null
          ? null
          : DateTime.parse(json['block_time'] as String)
      ..producerBlockId =
          ConversionHelper.getIntFromJson(json['producer_block_id'])
      ..receipt = json['receipt'] == null
          ? null
          : TransactionReceipt.fromJson(json['receipt'] as Map<String, dynamic>)
      ..elapsed = ConversionHelper.getIntFromJson(json['elapsed'])
      ..netUsage = ConversionHelper.getIntFromJson(json['net_usage'])
      ..scheduled = json['scheduled'] as bool?
      ..actionTraces = (json['action_traces'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : ActionWithReceipt.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$TransactionProcessedToJson(
        TransactionProcessed instance) =>
    <String, dynamic>{
      'id': instance.id,
      'block_num': instance.blockNum,
      'block_time': instance.blockTime?.toIso8601String(),
      'producer_block_id': instance.producerBlockId,
      'receipt': instance.receipt,
      'elapsed': instance.elapsed,
      'net_usage': instance.netUsage,
      'scheduled': instance.scheduled,
      'action_traces': instance.actionTraces,
    };
