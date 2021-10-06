import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';

@immutable
abstract class DelegateAUserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class OnUserSelected extends DelegateAUserEvent {
  final MemberModel user;

  OnUserSelected(this.user);

  @override
  String toString() => 'OnUserSelected: { User: $user }';
}

class OnConfirmDelegateTab extends DelegateAUserEvent {
  final MemberModel user;

  OnConfirmDelegateTab(this.user);

  @override
  String toString() => 'OnConfirmDelegateTab: { User: $user }';
}

class ClearPageCommand extends DelegateAUserEvent {
  @override
  String toString() => 'ClearPageCommand';
}
