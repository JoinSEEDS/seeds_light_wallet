part of 'vouch_for_a_member_bloc.dart';

abstract class VouchForAMemberEvent extends Equatable {
  const VouchForAMemberEvent();

  @override
  List<Object> get props => [];
}

class OnUserSelected extends VouchForAMemberEvent {
  final MemberModel user;

  const OnUserSelected(this.user);

  @override
  String toString() => 'OnUserSelected: { User: $user }';
}

class OnConfirmVouchForMemberTap extends VouchForAMemberEvent {
  final MemberModel user;

  const OnConfirmVouchForMemberTap(this.user);

  @override
  String toString() => 'OnConfirmVouchForMemberTap: { User: $user }';
}

class ClearPageCommand extends VouchForAMemberEvent {
  const ClearPageCommand();

  @override
  String toString() => 'ClearPageCommand';
}
