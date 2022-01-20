part of 'flag_user_bloc.dart';

class FlagUserState extends Equatable {
  final PageState pageState;
  final MemberModel? selectedMember;
  final List<String> noShowUsers;
  final PageCommand? pageCommand;

  const FlagUserState({
    required this.pageState,
    this.selectedMember,
    required this.noShowUsers,
    this.pageCommand,
  });

  @override
  List<Object?> get props => [
        pageState,
        selectedMember,
        noShowUsers,
        pageCommand,
      ];

  FlagUserState copyWith({
    PageState? pageState,
    MemberModel? selectedMember,
    List<String>? noShowUsers,
    PageCommand? pageCommand,
  }) {
    return FlagUserState(
      pageState: pageState ?? this.pageState,
      selectedMember: selectedMember ?? this.selectedMember,
      noShowUsers: noShowUsers ?? this.noShowUsers,
      pageCommand: pageCommand,
    );
  }

  factory FlagUserState.initial(List<MemberModel> alreadyVouched) {
    final List<String> noShowUsers = [settingsStorage.accountName];

    noShowUsers.addAll(alreadyVouched.map((e) => e.account));

    return FlagUserState(
      pageState: PageState.success,
      noShowUsers: noShowUsers,
    );
  }
}
