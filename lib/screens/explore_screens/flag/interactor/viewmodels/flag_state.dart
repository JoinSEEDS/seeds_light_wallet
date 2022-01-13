import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_command.dart';

class FlagState extends Equatable {
  final PageCommand? pageCommand;
  final List<MemberModel> usersIHaveFlagged;

  const FlagState({this.pageCommand, required this.usersIHaveFlagged});

  @override
  List<Object?> get props => [pageCommand];

  FlagState copyWith({
    PageCommand? pageCommand,
    List<MemberModel>? usersIHaveFlagged,
  }) {
    return FlagState(
      pageCommand: pageCommand,
      usersIHaveFlagged: usersIHaveFlagged ?? this.usersIHaveFlagged,
    );
  }

  factory FlagState.initial() => const FlagState(usersIHaveFlagged: []);
}
