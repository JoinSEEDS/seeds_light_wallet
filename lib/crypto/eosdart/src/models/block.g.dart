// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Block _$BlockFromJson(Map<String, dynamic> json) => Block(
      json['id'] as String?,
      ConversionHelper.getIntFromJson(json['block_num']),
    )
      ..timestamp = json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String)
      ..producer = json['producer'] as String?
      ..confirmed = json['confirmed'] as int?
      ..previous = json['previous'] as String?
      ..transactionMRoot = json['transaction_mroot'] as String?
      ..actionMRoot = json['action_mroot'] as String?
      ..scheduleVersion = json['schedule_version'] as int?
      ..newProducers = json['new_producers']
      ..headerExtensions = json['header_extensions'] as List<dynamic>?
      ..producerSignature = json['producer_signature'] as String?
      ..transactions = (json['transactions'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : TransactionReceipt.fromJson(e as Map<String, dynamic>))
          .toList()
      ..blockExtensions = json['block_extensions'] as List<dynamic>?
      ..refBlockPrefix = json['ref_block_prefix'] as int?;

Map<String, dynamic> _$BlockToJson(Block instance) => <String, dynamic>{
      'id': instance.id,
      'block_num': instance.blockNum,
      'timestamp': instance.timestamp?.toIso8601String(),
      'producer': instance.producer,
      'confirmed': instance.confirmed,
      'previous': instance.previous,
      'transaction_mroot': instance.transactionMRoot,
      'action_mroot': instance.actionMRoot,
      'schedule_version': instance.scheduleVersion,
      'new_producers': instance.newProducers,
      'header_extensions': instance.headerExtensions,
      'producer_signature': instance.producerSignature,
      'transactions': instance.transactions,
      'block_extensions': instance.blockExtensions,
      'ref_block_prefix': instance.refBlockPrefix,
    };
