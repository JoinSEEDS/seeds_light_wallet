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

class OnConfirmVouchForMemberTab extends VouchForAMemberEvent {
  final MemberModel user;

  const OnConfirmVouchForMemberTab(this.user);

  @override
  String toString() => 'OnConfirmDelegateTab: { User: $user }';
}
