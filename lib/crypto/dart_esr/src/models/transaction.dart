import 'dart:typed_data';
import 'package:json_annotation/json_annotation.dart';
import 'package:seeds/crypto/dart_esr/dart_esr.dart';
import 'package:seeds/crypto/eosdart/eosdart.dart' as eos;

part 'transaction.g.dart';

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

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  @override
  String toString() => toJson().toString();

  Uint8List toBinary(eos.Type transactionType) {
    final buffer = eos.SerialBuffer(Uint8List(0));
    transactionType.serialize!(transactionType, buffer, toJson());
    return buffer.asUint8List();
  }
}
