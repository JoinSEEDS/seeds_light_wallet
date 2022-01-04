// ignore_for_file: always_use_package_imports, directives_ordering, unnecessary_this

import 'package:json_annotation/json_annotation.dart';

import './transaction.dart';
import './conversion_helper.dart';

part 'block.g.dart';

@JsonSerializable()
class Block with ConversionHelper {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'block_num', fromJson: ConversionHelper.getIntFromJson)
  final int? blockNum;

  @JsonKey(name: 'timestamp')
  DateTime? timestamp;

  @JsonKey(name: 'producer')
  String? producer;

  @JsonKey(name: 'confirmed')
  int? confirmed;

  @JsonKey(name: 'previous')
  String? previous;

  @JsonKey(name: 'transaction_mroot')
  String? transactionMRoot;

  @JsonKey(name: 'action_mroot')
  String? actionMRoot;

  @JsonKey(name: 'schedule_version')
  int? scheduleVersion;

  @JsonKey(name: 'new_producers')
  Object? newProducers;

  @JsonKey(name: 'header_extensions')
  List<Object?>? headerExtensions;

  @JsonKey(name: 'producer_signature')
  String? producerSignature;

  @JsonKey(name: 'transactions')
  List<TransactionReceipt?>? transactions;

  @JsonKey(name: 'block_extensions')
  List<Object?>? blockExtensions;

  @JsonKey(name: 'ref_block_prefix')
  int? refBlockPrefix;

  Block(this.id, this.blockNum);

  factory Block.fromJson(Map<String, dynamic> json) => _$BlockFromJson(json);

  Map<String, dynamic> toJson() => _$BlockToJson(this);

  @override
  String toString() => this.toJson().toString();
}
