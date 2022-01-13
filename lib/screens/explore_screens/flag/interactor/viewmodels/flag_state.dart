import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';

class FlagState extends Equatable {
  final PageCommand? pageCommand;
  final List<ProfileModel> usersIHaveFlagged;
  final PageState pageState;
  final String? errorMessage;

  const FlagState({
    this.pageCommand,
    required this.usersIHaveFlagged,
    required this.pageState,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        pageCommand,
        usersIHaveFlagged,
        pageState,
        errorMessage,
      ];

  FlagState copyWith({
    PageCommand? pageCommand,
    List<ProfileModel>? usersIHaveFlagged,
    PageState? pageState,
    String? errorMessage,
  }) {
    return FlagState(
      pageCommand: pageCommand,
      usersIHaveFlagged: usersIHaveFlagged ?? this.usersIHaveFlagged,
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory FlagState.initial() => const FlagState(
        pageState: PageState.initial,
        usersIHaveFlagged: [],
      );
}
