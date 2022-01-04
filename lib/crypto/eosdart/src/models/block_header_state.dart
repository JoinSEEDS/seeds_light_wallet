// ignore_for_file: always_use_package_imports, unnecessary_this

import 'package:json_annotation/json_annotation.dart';

import './conversion_helper.dart';

part 'block_header_state.g.dart';

@JsonSerializable()
class BlockHeaderState with ConversionHelper {
  @JsonKey(name: 'id')
  String? id;

  @JsonKey(name: 'block_num', fromJson: ConversionHelper.getIntFromJson)
  int? blockNum;

  @JsonKey(name: 'header')
  Header? header;

  @JsonKey(
      name: 'dpos_proposed_irreversible_blocknum',
      fromJson: ConversionHelper.getIntFromJson)
  int? dposProposedIrreversibleBlocknum;

  @JsonKey(
      name: 'dpos_irreversible_blocknum',
      fromJson: ConversionHelper.getIntFromJson)
  int? dposIrreversibleBlocknum;

  @JsonKey(
      name: 'bft_irreversible_blocknum',
      fromJson: ConversionHelper.getIntFromJson)
  int? bftIrreversibleBlocknum;

  @JsonKey(
      name: 'pending_schedule_lib_num',
      fromJson: ConversionHelper.getIntFromJson)
  int? pendingScheduleLibNum;

  @JsonKey(name: 'pending_schedule_hash')
  String? pendingScheduleHash;

  @JsonKey(name: 'pending_schedule')
  Schedule? pendingSchedule;

  @JsonKey(name: 'active_schedule')
  Schedule? activeSchedule;

  @JsonKey(name: 'blockroot_merkle')
  BlockRootMerkle? blockrootMerkle;

  @JsonKey(name: 'producer_to_last_produced')
  List<List<Object?>?>? producerToLastProduced;

  @JsonKey(name: 'producer_to_last_implied_irb')
  List<List<Object?>?>? producerToLastImpliedIrb;

  @JsonKey(name: 'block_signing_key')
  String? blockSigningKey;

  @JsonKey(name: 'confirm_count')
  List<int>? confirmCount;

  @JsonKey(name: 'confirmations')
  List<Object?>? confirmations;

  BlockHeaderState();

  factory BlockHeaderState.fromJson(Map<String, dynamic> json) =>
      _$BlockHeaderStateFromJson(json);

  Map<String, dynamic> toJson() => _$BlockHeaderStateToJson(this);

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class Header {
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

  @JsonKey(name: 'header_extensions')
  List<Object?>? headerExtensions;

  @JsonKey(name: 'producer_signature')
  String? producerSignature;

  Header();

  factory Header.fromJson(Map<String, dynamic> json) => _$HeaderFromJson(json);

  Map<String, dynamic> toJson() => _$HeaderToJson(this);

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class Schedule {
  @JsonKey(name: 'version')
  int? version;

  @JsonKey(name: 'producers')
  List<Producer?>? producers;

  Schedule();

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleToJson(this);

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class Producer {
  @JsonKey(name: 'producer_name')
  String? producerName;

  @JsonKey(name: 'block_signing_key')
  String? blockSigningKey;

  Producer();

  factory Producer.fromJson(Map<String, dynamic> json) =>
      _$ProducerFromJson(json);

  Map<String, dynamic> toJson() => _$ProducerToJson(this);

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class BlockRootMerkle {
  @JsonKey(name: '_active_nodes')
  List<String>? activeNodes;

  @JsonKey(name: '_node_count')
  int? nodeCount;

  BlockRootMerkle();

  factory BlockRootMerkle.fromJson(Map<String, dynamic> json) =>
      _$BlockRootMerkleFromJson(json);

  Map<String, dynamic> toJson() => _$BlockRootMerkleToJson(this);

  @override
  String toString() => this.toJson().toString();
}
