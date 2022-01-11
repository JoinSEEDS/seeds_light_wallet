// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) {
  return Account(json['account_name'] as String?, json['head_block_num'] as int?)
    ..headBlockTime = json['head_block_time'] == null
        ? null
        : DateTime.parse(json['head_block_time'] as String)
    ..privileged = json['privileged'] as bool?
    ..lastCodeUpdate = json['last_code_update'] == null
        ? null
        : DateTime.parse(json['last_code_update'] as String)
    ..created = json['created'] == null
        ? null
        : DateTime.parse(json['created'] as String)
    ..coreLiquidBalance = json['core_liquid_balance'] == null
        ? null
        : Holding.fromJson(json['core_liquid_balance'] as String)
    ..ramQuota = json['ram_quota'] == null
        ? null
        : ConversionHelper.getIntFromJson(json['ram_quota'])
    ..netWeight = json['net_weight'] == null
        ? null
        : ConversionHelper.getIntFromJson(json['net_weight'])
    ..cpuWeight = json['cpu_weight'] == null
        ? null
        : ConversionHelper.getIntFromJson(json['cpu_weight'])
    ..netLimit = json['net_limit'] == null
        ? null
        : Limit.fromJson(json['net_limit'] as Map<String, dynamic>)
    ..cpuLimit = json['cpu_limit'] == null
        ? null
        : Limit.fromJson(json['cpu_limit'] as Map<String, dynamic>)
    ..ramUsage = json['ram_usage'] == null
        ? null
        : ConversionHelper.getIntFromJson(json['ram_usage'])
    ..totalResources = json['total_resources'] == null
        ? null
        : TotalResources.fromJson(
            json['total_resources'] as Map<String, dynamic>)
    ..permissions = (json['permissions'] as List?)
        ?.map((e) =>
            e == null ? null : Permission.fromJson(e as Map<String, dynamic>))
        .toList()
    ..selfDelegatedBandwidth = json['self_delegated_bandwidth'] == null
        ? null
        : SelfDelegatedBandwidth.fromJson(
            json['self_delegated_bandwidth'] as Map<String, dynamic>)
    ..refundRequest = json['refund_request'] == null
        ? null
        : RefundRequest.fromJson(json['refund_request'] as Map<String, dynamic>)
    ..voterInfo = json['voter_info'] == null
        ? null
        : VoterInfo.fromJson(json['voter_info'] as Map<String, dynamic>);
}

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'account_name': instance.accountName,
      'head_block_num': instance.headBlockNum,
      'head_block_time': instance.headBlockTime?.toIso8601String(),
      'privileged': instance.privileged,
      'last_code_update': instance.lastCodeUpdate?.toIso8601String(),
      'created': instance.created?.toIso8601String(),
      'core_liquid_balance': instance.coreLiquidBalance,
      'ram_quota': instance.ramQuota,
      'net_weight': instance.netWeight,
      'cpu_weight': instance.cpuWeight,
      'net_limit': instance.netLimit,
      'cpu_limit': instance.cpuLimit,
      'ram_usage': instance.ramUsage,
      'total_resources': instance.totalResources,
      'permissions': instance.permissions,
      'self_delegated_bandwidth': instance.selfDelegatedBandwidth,
      'refund_request': instance.refundRequest,
      'voter_info': instance.voterInfo
    };

Limit _$LimitFromJson(Map<String, dynamic> json) {
  return Limit()
    ..used = json['used'] == null
        ? null
        : ConversionHelper.getIntFromJson(json['used'])
    ..available = json['available'] == null
        ? null
        : ConversionHelper.getIntFromJson(json['available'])
    ..max = json['max'] == null
        ? null
        : ConversionHelper.getIntFromJson(json['max']);
}

Map<String, dynamic> _$LimitToJson(Limit instance) => <String, dynamic>{
      'used': instance.used,
      'available': instance.available,
      'max': instance.max
    };

Permission _$PermissionFromJson(Map<String, dynamic> json) {
  return Permission()
    ..permName = json['perm_name'] as String?
    ..parent = json['parent'] as String?
    ..requiredAuth = json['required_auth'] == null
        ? null
        : RequiredAuth.fromJson(json['required_auth'] as Map<String, dynamic>);
}

Map<String, dynamic> _$PermissionToJson(Permission instance) =>
    <String, dynamic>{
      'perm_name': instance.permName,
      'parent': instance.parent,
      'required_auth': instance.requiredAuth
    };

RequiredAuth _$RequiredAuthFromJson(Map<String, dynamic> json) {
  return RequiredAuth()
    ..threshold = json['threshold'] as int?
    ..keys = (json['keys'] as List?)
        ?.map((e) =>
            e == null ? null : AuthKey.fromJson(e as Map<String, dynamic>))
        .toList()
    ..accounts = (json['accounts'] as List?) as List<Object>?
    ..waits = (json['waits'] as List?) as List<Object>?;
}

Map<String, dynamic> _$RequiredAuthToJson(RequiredAuth instance) =>
    <String, dynamic>{
      'threshold': instance.threshold,
      'keys': instance.keys,
      'accounts': instance.accounts,
      'waits': instance.waits
    };

AuthKey _$AuthKeyFromJson(Map<String, dynamic> json) {
  return AuthKey()
    ..key = json['key'] as String?
    ..weight = json['weight'] as int?;
}

Map<String, dynamic> _$AuthKeyToJson(AuthKey instance) =>
    <String, dynamic>{'key': instance.key, 'weight': instance.weight};

TotalResources _$TotalResourcesFromJson(Map<String, dynamic> json) {
  return TotalResources()
    ..owner = json['owner'] as String?
    ..netWeight = json['net_weight'] == null
        ? null
        : Holding.fromJson(json['net_weight'] as String)
    ..cpuWeight = json['cpu_weight'] == null
        ? null
        : Holding.fromJson(json['cpu_weight'] as String)
    ..ramBytes = json['ram_bytes'] == null
        ? null
        : ConversionHelper.getIntFromJson(json['ram_bytes']);
}

Map<String, dynamic> _$TotalResourcesToJson(TotalResources instance) =>
    <String, dynamic>{
      'owner': instance.owner,
      'net_weight': instance.netWeight,
      'cpu_weight': instance.cpuWeight,
      'ram_bytes': instance.ramBytes
    };

SelfDelegatedBandwidth _$SelfDelegatedBandwidthFromJson(
    Map<String, dynamic> json) {
  return SelfDelegatedBandwidth()
    ..from = json['from'] as String?
    ..to = json['to'] as String?
    ..netWeight = json['net_weight'] == null
        ? null
        : Holding.fromJson(json['net_weight'] as String)
    ..cpuWeight = json['cpu_weight'] == null
        ? null
        : Holding.fromJson(json['cpu_weight'] as String);
}

Map<String, dynamic> _$SelfDelegatedBandwidthToJson(
        SelfDelegatedBandwidth instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'net_weight': instance.netWeight,
      'cpu_weight': instance.cpuWeight
    };

RefundRequest _$RefundRequestFromJson(Map<String, dynamic> json) {
  return RefundRequest()
    ..owner = json['owner'] as String?
    ..requestTime = json['request_time'] == null
        ? null
        : DateTime.parse(json['request_time'] as String)
    ..netAmount = json['net_amount'] == null
        ? null
        : Holding.fromJson(json['net_amount'] as String)
    ..cpuAmount = json['cpu_amount'] == null
        ? null
        : Holding.fromJson(json['cpu_amount'] as String);
}

Map<String, dynamic> _$RefundRequestToJson(RefundRequest instance) =>
    <String, dynamic>{
      'owner': instance.owner,
      'request_time': instance.requestTime?.toIso8601String(),
      'net_amount': instance.netAmount,
      'cpu_amount': instance.cpuAmount
    };

VoterInfo _$VoterInfoFromJson(Map<String, dynamic> json) {
  return VoterInfo()
    ..owner = json['owner'] as String?
    ..proxy = json['proxy'] as String?
    ..producers = json['producers']
    ..staked = json['staked'] == null
        ? null
        : ConversionHelper.getIntFromJson(json['staked'])
    ..lastVoteWeight = json['last_vote_weight'] as String?
    ..proxiedVoteWeight = json['proxied_vote_weight'] as String?
    ..isProxy = json['is_proxy'] as int?;
}

Map<String, dynamic> _$VoterInfoToJson(VoterInfo instance) => <String, dynamic>{
      'owner': instance.owner,
      'proxy': instance.proxy,
      'producers': instance.producers,
      'staked': instance.staked,
      'last_vote_weight': instance.lastVoteWeight,
      'proxied_vote_weight': instance.proxiedVoteWeight,
      'is_proxy': instance.isProxy
    };
