import 'package:equatable/equatable.dart';

abstract class MemberEvent extends Equatable {}

class OnLoadMemberData extends MemberEvent {
  final String account;
  OnLoadMemberData(this.account);

  @override
  String toString() => 'OnLoadMemberData';

  @override
  List<Object> get props => [account];
}

