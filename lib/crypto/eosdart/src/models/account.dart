// ignore_for_file: always_use_package_imports, unnecessary_this, prefer_final_locals, unnecessary_brace_in_string_interps, noop_primitive_operations

import 'package:json_annotation/json_annotation.dart';

import './conversion_helper.dart';

part 'account.g.dart';

/// Represents EOS account information
@JsonSerializable()
class Account with ConversionHelper {
  @JsonKey(name: 'account_name')
  final String? accountName;

  @JsonKey(name: 'head_block_num')
  final int? headBlockNum;

  @JsonKey(name: 'head_block_time')
  DateTime? headBlockTime;

  @JsonKey(name: 'privileged')
  bool? privileged;

  @JsonKey(name: 'last_code_update')
  DateTime? lastCodeUpdate;

  @JsonKey(name: 'created')
  DateTime? created;

  @JsonKey(name: 'core_liquid_balance')
  Holding? coreLiquidBalance;

  @JsonKey(name: 'ram_quota', fromJson: ConversionHelper.getIntFromJson)
  int? ramQuota;

  @JsonKey(name: 'net_weight', fromJson: ConversionHelper.getIntFromJson)
  int? netWeight;

  @JsonKey(name: 'cpu_weight', fromJson: ConversionHelper.getIntFromJson)
  int? cpuWeight;

  @JsonKey(name: 'net_limit')
  Limit? netLimit;

  @JsonKey(name: 'cpu_limit')
  Limit? cpuLimit;

  @JsonKey(name: 'ram_usage', fromJson: ConversionHelper.getIntFromJson)
  int? ramUsage;

  @JsonKey(name: 'total_resources')
  TotalResources? totalResources;

  @JsonKey(name: 'permissions')
  List<Permission?>? permissions;

  @JsonKey(name: 'self_delegated_bandwidth')
  SelfDelegatedBandwidth? selfDelegatedBandwidth;

  @JsonKey(name: 'refund_request')
  RefundRequest? refundRequest;

  @JsonKey(name: 'voter_info')
  VoterInfo? voterInfo;

  Account(this.accountName, this.headBlockNum);

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class Limit with ConversionHelper {
  @JsonKey(name: 'used', fromJson: ConversionHelper.getIntFromJson)
  int? used;

  @JsonKey(name: 'available', fromJson: ConversionHelper.getIntFromJson)
  int? available;

  @JsonKey(name: 'max', fromJson: ConversionHelper.getIntFromJson)
  int? max;

  Limit();

  factory Limit.fromJson(Map<String, dynamic> json) => _$LimitFromJson(json);

  Map<String, dynamic> toJson() => _$LimitToJson(this);

  @override
  String toString() => this.toJson().toString();
}

// this is not using json serializer as it is customized serializer to
// convert the amount currency split by space
/// Structure for the JSON string format e.g. '1.0000 EOS', it splits that by
/// 'amount' and 'currency'
class Holding {
  double? amount;
  String? currency;

  Holding.fromJson(String json) {
    List<String> segments = json.split(" ");
    if (segments.length != 2) {
      return;
    }
    this.amount = double.parse(segments[0]);
    this.currency = segments[1];
  }

  String toJson() => '${amount} ${currency}';

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class Permission {
  @JsonKey(name: 'perm_name')
  String? permName;

  @JsonKey(name: 'parent')
  String? parent;

  @JsonKey(name: 'required_auth')
  RequiredAuth? requiredAuth;

  Permission();

  factory Permission.fromJson(Map<String, dynamic> json) =>
      _$PermissionFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionToJson(this);

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class RequiredAuth {
  @JsonKey(name: 'threshold')
  int? threshold;

  @JsonKey(name: 'keys')
  List<AuthKey?>? keys;

  @JsonKey(name: 'accounts')
  List<Object?>? accounts;

  @JsonKey(name: 'waits')
  List<Object?>? waits;

  RequiredAuth();

  factory RequiredAuth.fromJson(Map<String, dynamic> json) =>
      _$RequiredAuthFromJson(json);

  Map<String, dynamic> toJson() => _$RequiredAuthToJson(this);

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class AuthKey {
  @JsonKey(name: 'key')
  String? key;

  @JsonKey(name: 'weight')
  int? weight;

  AuthKey();

  factory AuthKey.fromJson(Map<String, dynamic> json) =>
      _$AuthKeyFromJson(json);

  Map<String, dynamic> toJson() => _$AuthKeyToJson(this);

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class TotalResources with ConversionHelper {
  @JsonKey(name: 'owner')
  String? owner;

  @JsonKey(name: 'net_weight')
  Holding? netWeight;

  @JsonKey(name: 'cpu_weight')
  Holding? cpuWeight;

  @JsonKey(name: 'ram_bytes', fromJson: ConversionHelper.getIntFromJson)
  int? ramBytes;

  TotalResources();

  factory TotalResources.fromJson(Map<String, dynamic> json) =>
      _$TotalResourcesFromJson(json);

  Map<String, dynamic> toJson() => _$TotalResourcesToJson(this);

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class SelfDelegatedBandwidth {
  @JsonKey(name: 'from')
  String? from;

  @JsonKey(name: 'to')
  String? to;

  @JsonKey(name: 'net_weight')
  Holding? netWeight;

  @JsonKey(name: 'cpu_weight')
  Holding? cpuWeight;

  SelfDelegatedBandwidth();

  factory SelfDelegatedBandwidth.fromJson(Map<String, dynamic> json) =>
      _$SelfDelegatedBandwidthFromJson(json);

  Map<String, dynamic> toJson() => _$SelfDelegatedBandwidthToJson(this);

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class RefundRequest {
  @JsonKey(name: 'owner')
  String? owner;

  @JsonKey(name: 'request_time')
  DateTime? requestTime;

  @JsonKey(name: 'net_amount')
  Holding? netAmount;

  @JsonKey(name: 'cpu_amount')
  Holding? cpuAmount;

  RefundRequest();

  factory RefundRequest.fromJson(Map<String, dynamic> json) =>
      _$RefundRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RefundRequestToJson(this);

  @override
  String toString() => this.toJson().toString();
}

@JsonSerializable()
class VoterInfo with ConversionHelper {
  @JsonKey(name: 'owner')
  String? owner;

  @JsonKey(name: 'proxy')
  String? proxy;

  @JsonKey(name: 'producers')
  Object? producers;

  @JsonKey(name: 'staked', fromJson: ConversionHelper.getIntFromJson)
  int? staked;

  @JsonKey(name: 'last_vote_weight')
  String? lastVoteWeight;

  @JsonKey(name: 'proxied_vote_weight')
  String? proxiedVoteWeight;

  @JsonKey(name: 'is_proxy')
  int? isProxy;

  VoterInfo();

  factory VoterInfo.fromJson(Map<String, dynamic> json) =>
      _$VoterInfoFromJson(json);

  Map<String, dynamic> toJson() => _$VoterInfoToJson(this);

  @override
  String toString() => this.toJson().toString();
}
