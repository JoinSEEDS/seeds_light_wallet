// ignore_for_file: always_use_package_imports, unnecessary_this

import 'package:json_annotation/json_annotation.dart';

import './action.dart';
import './conversion_helper.dart';

part 'action_block.g.dart';

@JsonSerializable()
class Actions {
  @JsonKey(name: 'actions')
  List<ActionBlock?>? actions;

  Actions();

  factory Actions.fromJson(Map<String, dynamic> json) =>
      _$ActionsFromJson(json);

  Map<String, dynamic> toJson() => _$ActionsToJson(this);

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class ActionBlock with ConversionHelper {
  @JsonKey(name: 'global_action_seq', fromJson: ConversionHelper.getIntFromJson)
  int? globalActionSeq;

  @JsonKey(
      name: 'account_action_seq', fromJson: ConversionHelper.getIntFromJson)
  int? accountActionSeq;

  @JsonKey(name: 'block_num', fromJson: ConversionHelper.getIntFromJson)
  int? blockNum;

  @JsonKey(name: 'block_time')
  DateTime? blockTime;

  @JsonKey(name: 'action_trace')
  ActionWithReceipt? actionTrace;

  ActionBlock();

  factory ActionBlock.fromJson(Map<String, dynamic> json) =>
      _$ActionBlockFromJson(json);

  Map<String, dynamic> toJson() => _$ActionBlockToJson(this);

  @override
  String toString() => this.toJson().toString();
}
