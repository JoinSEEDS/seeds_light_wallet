part of 'flag_bloc.dart';

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
