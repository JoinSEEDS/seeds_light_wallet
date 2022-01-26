part of 'vouch_for_a_member_bloc.dart';

abstract class VouchForAMemberEvent extends Equatable {
  const VouchForAMemberEvent();

  @override
  List<Object?> get props => [];
}

class OnUserSelected extends VouchForAMemberEvent {
  final ProfileModel user;

  const OnUserSelected(this.user);

  @override
  String toString() => 'OnUserSelected: { User: $user }';
}

class OnConfirmVouchForMemberTap extends VouchForAMemberEvent {
  @override
  String toString() => 'OnConfirmVouchForMemberTap';
}

class ClearPageCommand extends VouchForAMemberEvent {
  const ClearPageCommand();

  @override
  String toString() => 'ClearPageCommand';
}
