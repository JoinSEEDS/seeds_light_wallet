// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:collection/collection.dart';

/// Permissions

class EOSKeyAuth {
  final String key;
  final int weight;
  EOSKeyAuth({required this.key, required this.weight});
  EOSKeyAuth.fromJson(Map<String, dynamic> json)
    : key = json['key'] as String,
      weight = json['weight'] as int;
  Map<String, dynamic> toJson() => {
    'key': key,
    'weight': weight,
  };
}

class EOSAccountAuthPermission {
  final String actor; 
  final String permission;
  EOSAccountAuthPermission({required this.actor, required this.permission});
  EOSAccountAuthPermission.fromJson(Map<String, dynamic> json)
    : actor = json['actor'] as String,
      permission = json['permission'] as String;
  Map<String, dynamic> toJson() => {
    'actor': actor,
    'permission': permission,
  };
}
class EOSAccountAuth {
  final EOSAccountAuthPermission permission;
  final int weight;
  EOSAccountAuth({required this.permission, required this.weight});
  EOSAccountAuth.fromJson(Map<String, dynamic> json)
    : permission = EOSAccountAuthPermission.fromJson(json['permission'] as Map<String, dynamic>),
      weight = json['weight'] as int;
  Map<String, dynamic> toJson() => {
    'permission': permission.toJson(),
    'weight': weight,
  };
}
class EOSAccountRequiredAuth {
  final int threshold;
  final List<EOSKeyAuth> keys;
  final List<EOSAccountAuth> accounts;
  final List<dynamic> waits;
  EOSAccountRequiredAuth({
    required this.threshold,
    required this.keys,
    required this.accounts,
    required this.waits,
    });
  EOSAccountRequiredAuth copyWith({
    int? threshold,
    List<EOSKeyAuth>? keys,
    List<EOSAccountAuth>? accounts,
    List<dynamic>? waits,
  }) {
    return EOSAccountRequiredAuth(
      threshold: threshold ?? this.threshold,
      keys: keys ?? this.keys,
      accounts: accounts ?? this.accounts,
      waits: waits ?? this.waits,
    );
  }
  EOSAccountRequiredAuth.fromJson(Map<String, dynamic> json) 
    : threshold = json['threshold'] as int,
      keys = (json['keys'] as List)
        .map((e) => EOSKeyAuth.fromJson(e as Map<String, dynamic>)).toList()
        .sorted((a, b) => a.key.compareTo(b.key)),
      accounts = (json['accounts'] as List)
        .map((e) => EOSAccountAuth.fromJson(e as Map<String, dynamic>)).toList()
        .sorted((a, b) => a.permission.actor.compareTo(b.permission.actor)),
      waits = json['waits'] as List<dynamic>;
  Map<String, dynamic> toJson() => {
    'threshold': threshold,
    'keys': keys.sorted((a, b) => a.key.compareTo(b.key)).map((e) => e.toJson()).toList(),
    'accounts': 
      accounts.sorted((a, b) => a.permission.actor.compareTo(b.permission.actor))
        .map((e) => e.toJson()).toList(),
    'waits': waits,
  };
}
class EOSLinkedAction {
  final String account;
  final String action;
  EOSLinkedAction({required this.account, required this.action});
  EOSLinkedAction.fromJson(Map<String, dynamic> json)
    : account = json['account'] as String,
      action = json['action'] as String;
  Map<String, dynamic> toJson() => {
    'account': account,
    'action': action,
  };
}
class EOSPermission {
  final String perm_name;
  final String parent;
  final EOSAccountRequiredAuth required_auth;
  final List<EOSLinkedAction> linked_actions;
  const EOSPermission({
    required this.perm_name,
    required this.parent,
    required this.required_auth,
    required this.linked_actions
  });
  EOSPermission.fromJson(Map<String, dynamic> json)
    : perm_name = json['perm_name'] as String,
      parent = json['parent'] as String,
      required_auth = EOSAccountRequiredAuth.fromJson((json['required_auth'] as Map<String, dynamic>)),
      linked_actions = (json['linked_actions'] as List)
        .map((e) => EOSLinkedAction.fromJson(e as Map<String, dynamic>)).toList();
  Map<String, dynamic> toJson() => {
    'perm_name': perm_name,
    'parent': parent,
    'required_auth': required_auth.toJson(),
    'linked_actions': linked_actions,
  };
}

class EOSPermissionsModel {
  final List<EOSPermission> permissions;

  const EOSPermissionsModel({required this.permissions});

  EOSPermissionsModel.fromJson(Map<String, dynamic> json)
    : permissions = (json['permissions'] as List).map((e) => EOSPermission.fromJson(e as Map<String, dynamic>)).toList();
  Map<String, dynamic> toJson() => {
    'permissions': permissions,
  };
}
