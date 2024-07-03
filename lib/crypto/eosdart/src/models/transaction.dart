// ignore_for_file: always_use_package_imports, unnecessary_this, prefer_final_locals

import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

import '../eosdart_base.dart';
import '../serialize.dart' as ser;
import './action.dart';
import './conversion_helper.dart';

part 'transaction.g.dart';

@JsonSerializable()
class TransactionBlock with ConversionHelper {
  @JsonKey(name: 'id')
  String? id;

  @JsonKey(name: 'trx')
  TransactionWithReceipt? trx;

  @JsonKey(name: 'block_time')
  DateTime? blockTime;

  @JsonKey(name: 'block_num', fromJson: ConversionHelper.getIntFromJson)
  int? blockNum;

  @JsonKey(
      name: 'last_irreversible_block',
      fromJson: ConversionHelper.getIntFromJson)
  int? lastIrreversibleBlock;

  @JsonKey(name: 'traces')
  List<ActionWithReceipt?>? traces;

  TransactionBlock();

  factory TransactionBlock.fromJson(Map<String, dynamic> json) =>
      _$TransactionBlockFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionBlockToJson(this);

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class TransactionWithReceipt {
  @JsonKey(name: 'receipt')
  TransactionReceipt? receipt;

  @JsonKey(name: 'trx')
  Transaction? transaction;

  TransactionWithReceipt();

  factory TransactionWithReceipt.fromJson(Map<String, dynamic> json) =>
      _$TransactionWithReceiptFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionWithReceiptToJson(this);

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class TransactionReceipt with ConversionHelper {
  @JsonKey(name: 'status')
  String? status;

  @JsonKey(name: 'cpu_usage_us', fromJson: ConversionHelper.getIntFromJson)
  int? cpuUsageUs;

  @JsonKey(name: 'net_usage_words', fromJson: ConversionHelper.getIntFromJson)
  int? netUsageWords;

  @JsonKey(name: 'trx')
  Object? trx;

  TransactionReceipt();

  factory TransactionReceipt.fromJson(Map<String, dynamic> json) =>
      _$TransactionReceiptFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionReceiptToJson(this);

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable(explicitToJson: true)
class Transaction {
  @JsonKey(name: 'expiration')
  DateTime? expiration;

  @JsonKey(name: 'ref_block_num')
  int? refBlockNum;

  @JsonKey(name: 'ref_block_prefix')
  int? refBlockPrefix;

  @JsonKey(name: 'max_net_usage_words')
  int? maxNetUsageWords = 0;

  @JsonKey(name: 'max_cpu_usage_ms')
  int? maxCpuUsageMs = 0;

  @JsonKey(name: 'delay_sec')
  int? delaySec = 0;

  @JsonKey(name: 'context_free_actions')
  List<Object?>? contextFreeActions = [];

  @JsonKey(name: 'actions')
  List<Action?>? actions = [];

  @JsonKey(name: 'transaction_extensions')
  List<Object?>? transactionExtensions = [];

  @JsonKey(name: 'signatures')
  List<String>? signatures = [];

  @JsonKey(name: 'context_free_data')
  List<Object?>? contextFreeData = [];

  Transaction();

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  @override
  String toString() => this.toJson().toString();

  Uint8List toBinary(Type transactionType) {
    var buffer = ser.SerialBuffer(Uint8List(0));
    transactionType.serialize!(transactionType, buffer, this.toJson());
    return buffer.asUint8List();
  }
}

@JsonSerializable()
class TransactionCommitted {
  @JsonKey(name: 'transaction_id')
  String? id;

  @JsonKey(name: 'processed')
  TransactionProcessed? processed;

  TransactionCommitted();

  factory TransactionCommitted.fromJson(Map<String, dynamic> json) =>
      _$TransactionCommittedFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionCommittedToJson(this);

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class TransactionProcessed with ConversionHelper {
  @JsonKey(name: 'id')
  String? id;

  @JsonKey(name: 'block_num', fromJson: ConversionHelper.getIntFromJson)
  int? blockNum;

  @JsonKey(name: 'block_time')
  DateTime? blockTime;

  @JsonKey(name: 'producer_block_id', fromJson: ConversionHelper.getIntFromJson)
  int? producerBlockId;

  @JsonKey(name: 'receipt')
  TransactionReceipt? receipt;

  @JsonKey(name: 'elapsed', fromJson: ConversionHelper.getIntFromJson)
  int? elapsed;

  @JsonKey(name: 'net_usage', fromJson: ConversionHelper.getIntFromJson)
  int? netUsage;

  @JsonKey(name: 'scheduled')
  bool? scheduled;

  @JsonKey(name: 'action_traces')
  List<ActionWithReceipt?>? actionTraces;

  TransactionProcessed();

  factory TransactionProcessed.fromJson(Map<String, dynamic> json) =>
      _$TransactionProcessedFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionProcessedToJson(this);

  @override
  String toString() => this.toJson().toString();
}
