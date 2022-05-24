import 'package:json_annotation/json_annotation.dart';

part 'txInfoData.g.dart';

/// call api.tx[module][call](...params) with polkadot-js/api
/// see https://polkadot.js.org/api/substrate/extrinsics.html
/// for all available calls and params.
@JsonSerializable(explicitToJson: true)
class TxInfoData {
  TxInfoData(
    this.module,
    this.call,
    this.sender, {
    this.tip = '0',
    this.isUnsigned = false,
    this.proxy,
    this.txName,
  });

  String? module;
  String? call;
  TxSenderData? sender;
  String? tip;

  bool? isUnsigned;

  /// proxy for calling recovery.asRecovered
  TxSenderData? proxy;

  /// txName for calling treasury.approveProposal & treasury.rejectProposal
  String? txName;

  Map<String, dynamic> toJson() => _$TxInfoDataToJson(this);
}

@JsonSerializable()
class TxSenderData {
  TxSenderData(this.address, this.pubKey);

  final String? address;
  final String? pubKey;

  static TxSenderData fromJson(Map<String, dynamic> json) =>
      _$TxSenderDataFromJson(json);
  Map<String, dynamic> toJson() => _$TxSenderDataToJson(this);
}

@JsonSerializable()
class TxFeeEstimateResult extends _TxFeeEstimateResult {
  static TxFeeEstimateResult fromJson(Map<String, dynamic> json) =>
      _$TxFeeEstimateResultFromJson(json);
  Map<String, dynamic> toJson() => _$TxFeeEstimateResultToJson(this);
}

abstract class _TxFeeEstimateResult {
  dynamic weight;
  dynamic partialFee;
}
