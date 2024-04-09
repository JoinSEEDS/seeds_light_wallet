// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionWithReceipt _$ActionWithReceiptFromJson(Map<String, dynamic> json) =>
    ActionWithReceipt()
      ..receipt = json['receipt'] == null
          ? null
          : ActionReceipt.fromJson(json['receipt'] as Map<String, dynamic>)
      ..action = json['act'] == null
          ? null
          : Action.fromJson(json['act'] as Map<String, dynamic>)
      ..contextFree = json['context_free'] as bool?
      ..elapsed = json['elapsed'] as int?
      ..console = json['console'] as String?
      ..trxId = json['trx_id'] as String?
      ..blockNum = ConversionHelper.getIntFromJson(json['block_num'])
      ..blockTime = json['block_time'] == null
          ? null
          : DateTime.parse(json['block_time'] as String)
      ..producerBlockId = json['producer_block_id'] as String?
      ..accountRamDeltas = json['account_ram_deltas'] as List<dynamic>?
      ..except = json['except']
      ..inlineTraces = (json['inline_traces'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : ActionWithReceipt.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ActionWithReceiptToJson(ActionWithReceipt instance) =>
    <String, dynamic>{
      'receipt': instance.receipt,
      'act': instance.action,
      'context_free': instance.contextFree,
      'elapsed': instance.elapsed,
      'console': instance.console,
      'trx_id': instance.trxId,
      'block_num': instance.blockNum,
      'block_time': instance.blockTime?.toIso8601String(),
      'producer_block_id': instance.producerBlockId,
      'account_ram_deltas': instance.accountRamDeltas,
      'except': instance.except,
      'inline_traces': instance.inlineTraces,
    };

Action _$ActionFromJson(Map<String, dynamic> json) => Action()
  ..account = json['account'] as String?
  ..name = json['name'] as String?
  ..authorization = (json['authorization'] as List<dynamic>?)
      ?.map((e) =>
          e == null ? null : Authorization.fromJson(e as Map<String, dynamic>))
      .toList()
  ..data = json['data'];

Map<String, dynamic> _$ActionToJson(Action instance) => <String, dynamic>{
      'account': instance.account,
      'name': instance.name,
      'authorization': instance.authorization?.map((e) => e?.toJson()).toList(),
      'data': instance.data,
    };

ActionArgs _$ActionArgsFromJson(Map<String, dynamic> json) => ActionArgs()
  ..fromAccount = json['from'] as String?
  ..toAccount = json['to'] as String?
  ..quantity = json['quantity'] as String?
  ..memo = json['memo'] as String?;

Map<String, dynamic> _$ActionArgsToJson(ActionArgs instance) =>
    <String, dynamic>{
      'from': instance.fromAccount,
      'to': instance.toAccount,
      'quantity': instance.quantity,
      'memo': instance.memo,
    };

ActionReceipt _$ActionReceiptFromJson(Map<String, dynamic> json) =>
    ActionReceipt()
      ..receiver = json['receiver'] as String?
      ..actDigest = json['act_digest'] as String?
      ..globalSequence =
          ConversionHelper.getIntFromJson(json['global_sequence'])
      ..receiveSequence = ConversionHelper.getIntFromJson(json['recv_sequence'])
      ..authSequence = json['auth_sequence'] as List<dynamic>?
      ..codeSequence = ConversionHelper.getIntFromJson(json['code_sequence'])
      ..abiSequence = ConversionHelper.getIntFromJson(json['abi_sequence']);

Map<String, dynamic> _$ActionReceiptToJson(ActionReceipt instance) =>
    <String, dynamic>{
      'receiver': instance.receiver,
      'act_digest': instance.actDigest,
      'global_sequence': instance.globalSequence,
      'recv_sequence': instance.receiveSequence,
      'auth_sequence': instance.authSequence,
      'code_sequence': instance.codeSequence,
      'abi_sequence': instance.abiSequence,
    };

Authorization _$AuthorizationFromJson(Map<String, dynamic> json) =>
    Authorization()
      ..actor = json['actor'] as String?
      ..permission = json['permission'] as String?;

Map<String, dynamic> _$AuthorizationToJson(Authorization instance) =>
    <String, dynamic>{
      'actor': instance.actor,
      'permission': instance.permission,
    };
