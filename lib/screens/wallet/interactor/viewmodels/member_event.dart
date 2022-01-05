part of 'member_bloc.dart';

abstract class MemberEvent extends Equatable {
  const MemberEvent();

  @override
  List<Object?> get props => [];
}

class OnLoadMemberData extends MemberEvent {
  const OnLoadMemberData();

  @override
  String toString() => 'OnLoadMemberData';
}
