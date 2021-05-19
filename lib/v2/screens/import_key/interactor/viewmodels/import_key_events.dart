import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class ImportKeyEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FindAccountByKey extends ImportKeyEvent {
  final String userKey;

  FindAccountByKey({required this.userKey});

  @override
  String toString() => 'FindAccountByKey';
}

class AccountSelected extends ImportKeyEvent {
  final String account;

  AccountSelected({required this.account});

  @override
  String toString() => 'AccountSelected: { account: $account }';
}
