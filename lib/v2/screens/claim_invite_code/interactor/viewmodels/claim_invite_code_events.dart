import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class ClaimInviteCodeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FindAccountByKey extends ClaimInviteCodeEvent {
  final String userKey;

  FindAccountByKey({@required this.userKey}) : assert(userKey != null);

  @override
  String toString() => 'FindAccountByKey: { userKey: $userKey }';
}

class AccountSelected extends ClaimInviteCodeEvent {
  final String account;

  AccountSelected({@required this.account}) : assert(account != null);

  @override
  String toString() => 'AccountSelected: { account: $account }';
}
