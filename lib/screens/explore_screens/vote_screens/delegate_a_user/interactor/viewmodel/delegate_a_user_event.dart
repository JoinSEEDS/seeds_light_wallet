part of 'delegate_a_user_bloc.dart';

abstract class DelegateAUserEvent extends Equatable {
  const DelegateAUserEvent();

  @override
  List<Object?> get props => [];
}

class OnUserSelected extends DelegateAUserEvent {
  final ProfileModel user;

  const OnUserSelected(this.user);

  @override
  String toString() => 'OnUserSelected: { User: $user }';
}

class OnConfirmDelegateTab extends DelegateAUserEvent {
  final ProfileModel user;

  const OnConfirmDelegateTab(this.user);

  @override
  String toString() => 'OnConfirmDelegateTab: { User: $user }';
}

class ClearPageCommand extends DelegateAUserEvent {
  const ClearPageCommand();

  @override
  String toString() => 'ClearPageCommand';
}
