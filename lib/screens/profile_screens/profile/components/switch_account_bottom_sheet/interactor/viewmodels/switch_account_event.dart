part of 'switch_account_bloc.dart';

@immutable
abstract class SwitchAccountEvent extends Equatable {
  const SwitchAccountEvent();

  @override
  List<Object> get props => [];
}

class FindAccountsByKey extends SwitchAccountEvent {
  const FindAccountsByKey();

  @override
  String toString() => 'FindAccountsByKey';
}

class OnAccountSelected extends SwitchAccountEvent {
  final String account;

  const OnAccountSelected({required this.account});

  @override
  String toString() => 'OnAccountSelected: { account: $account }';
}
