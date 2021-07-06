import 'package:equatable/equatable.dart';

abstract class MemberEvent extends Equatable {}

class LoadMemberDataEvent extends MemberEvent {
  final String account;
  LoadMemberDataEvent(this.account);

  @override
  List<Object> get props => [account];
}
