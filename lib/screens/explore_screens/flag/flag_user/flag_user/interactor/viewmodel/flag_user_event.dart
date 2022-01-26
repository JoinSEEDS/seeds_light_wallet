part of 'flag_user_bloc.dart';

abstract class FlagUserEvent extends Equatable {
  const FlagUserEvent();

  @override
  List<Object?> get props => [];
}

class OnUserSelected extends FlagUserEvent {
  final ProfileModel profile;

  const OnUserSelected(this.profile);

  @override
  String toString() => 'OnUserSelected: { User: $profile }';
}

class OnConfirmFlagUserTap extends FlagUserEvent {
  @override
  String toString() => 'OnConfirmFlagUserTap';
}

class ClearPageCommand extends FlagUserEvent {
  const ClearPageCommand();

  @override
  String toString() => 'ClearPageCommand';
}
