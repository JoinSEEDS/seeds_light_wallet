// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_header_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockHeaderState _$BlockHeaderStateFromJson(Map<String, dynamic> json) =>
    BlockHeaderState()
      ..id = json['id'] as String?
      ..blockNum = ConversionHelper.getIntFromJson(json['block_num'])
      ..header = json['header'] == null
          ? null
          : Header.fromJson(json['header'] as Map<String, dynamic>)
      ..dposProposedIrreversibleBlocknum = ConversionHelper.getIntFromJson(
          json['dpos_proposed_irreversible_blocknum'])
      ..dposIrreversibleBlocknum =
          ConversionHelper.getIntFromJson(json['dpos_irreversible_blocknum'])
      ..bftIrreversibleBlocknum =
          ConversionHelper.getIntFromJson(json['bft_irreversible_blocknum'])
      ..pendingScheduleLibNum =
          ConversionHelper.getIntFromJson(json['pending_schedule_lib_num'])
      ..pendingScheduleHash = json['pending_schedule_hash'] as String?
      ..pendingSchedule = json['pending_schedule'] == null
          ? null
          : Schedule.fromJson(json['pending_schedule'] as Map<String, dynamic>)
      ..activeSchedule = json['active_schedule'] == null
          ? null
          : Schedule.fromJson(json['active_schedule'] as Map<String, dynamic>)
      ..blockrootMerkle = json['blockroot_merkle'] == null
          ? null
          : BlockRootMerkle.fromJson(
              json['blockroot_merkle'] as Map<String, dynamic>)
      ..producerToLastProduced =
          (json['producer_to_last_produced'] as List<dynamic>?)
              ?.map((e) => e as List<dynamic>?)
              .toList()
      ..producerToLastImpliedIrb =
          (json['producer_to_last_implied_irb'] as List<dynamic>?)
              ?.map((e) => e as List<dynamic>?)
              .toList()
      ..blockSigningKey = json['block_signing_key'] as String?
      ..confirmCount = (json['confirm_count'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList()
      ..confirmations = json['confirmations'] as List<dynamic>?;

Map<String, dynamic> _$BlockHeaderStateToJson(BlockHeaderState instance) =>
    <String, dynamic>{
      'id': instance.id,
      'block_num': instance.blockNum,
      'header': instance.header,
      'dpos_proposed_irreversible_blocknum':
          instance.dposProposedIrreversibleBlocknum,
      'dpos_irreversible_blocknum': instance.dposIrreversibleBlocknum,
      'bft_irreversible_blocknum': instance.bftIrreversibleBlocknum,
      'pending_schedule_lib_num': instance.pendingScheduleLibNum,
      'pending_schedule_hash': instance.pendingScheduleHash,
      'pending_schedule': instance.pendingSchedule,
      'active_schedule': instance.activeSchedule,
      'blockroot_merkle': instance.blockrootMerkle,
      'producer_to_last_produced': instance.producerToLastProduced,
      'producer_to_last_implied_irb': instance.producerToLastImpliedIrb,
      'block_signing_key': instance.blockSigningKey,
      'confirm_count': instance.confirmCount,
      'confirmations': instance.confirmations,
    };

Header _$HeaderFromJson(Map<String, dynamic> json) => Header()
  ..timestamp = json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String)
  ..producer = json['producer'] as String?
  ..confirmed = (json['confirmed'] as num?)?.toInt()
  ..previous = json['previous'] as String?
  ..transactionMRoot = json['transaction_mroot'] as String?
  ..actionMRoot = json['action_mroot'] as String?
  ..scheduleVersion = (json['schedule_version'] as num?)?.toInt()
  ..headerExtensions = json['header_extensions'] as List<dynamic>?
  ..producerSignature = json['producer_signature'] as String?;

Map<String, dynamic> _$HeaderToJson(Header instance) => <String, dynamic>{
      'timestamp': instance.timestamp?.toIso8601String(),
      'producer': instance.producer,
      'confirmed': instance.confirmed,
      'previous': instance.previous,
      'transaction_mroot': instance.transactionMRoot,
      'action_mroot': instance.actionMRoot,
      'schedule_version': instance.scheduleVersion,
      'header_extensions': instance.headerExtensions,
      'producer_signature': instance.producerSignature,
    };

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule()
  ..version = (json['version'] as num?)?.toInt()
  ..producers = (json['producers'] as List<dynamic>?)
      ?.map((e) =>
          e == null ? null : Producer.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'version': instance.version,
      'producers': instance.producers,
    };

Producer _$ProducerFromJson(Map<String, dynamic> json) => Producer()
  ..producerName = json['producer_name'] as String?
  ..blockSigningKey = json['block_signing_key'] as String?;

Map<String, dynamic> _$ProducerToJson(Producer instance) => <String, dynamic>{
      'producer_name': instance.producerName,
      'block_signing_key': instance.blockSigningKey,
    };

BlockRootMerkle _$BlockRootMerkleFromJson(Map<String, dynamic> json) =>
    BlockRootMerkle()
      ..activeNodes = (json['_active_nodes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..nodeCount = (json['_node_count'] as num?)?.toInt();

Map<String, dynamic> _$BlockRootMerkleToJson(BlockRootMerkle instance) =>
    <String, dynamic>{
      '_active_nodes': instance.activeNodes,
      '_node_count': instance.nodeCount,
    };
