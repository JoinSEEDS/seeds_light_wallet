part of 'flag_user_bloc.dart';

class FlagUserState extends Equatable {
  final PageState pageState;
  final ProfileModel? selectedProfile;
  final List<String> noShowUsers;
  final PageCommand? pageCommand;

  const FlagUserState({
    required this.pageState,
    this.selectedProfile,
    required this.noShowUsers,
    this.pageCommand,
  });

  @override
  List<Object?> get props => [
        pageState,
        selectedProfile,
        noShowUsers,
        pageCommand,
      ];

  FlagUserState copyWith({
    PageState? pageState,
    ProfileModel? selectedProfile,
    List<String>? noShowUsers,
    PageCommand? pageCommand,
  }) {
    return FlagUserState(
      pageState: pageState ?? this.pageState,
      selectedProfile: selectedProfile ?? this.selectedProfile,
      noShowUsers: noShowUsers ?? this.noShowUsers,
      pageCommand: pageCommand,
    );
  }

  factory FlagUserState.initial(List<ProfileModel> alreadyFlagged) {
    final List<String> noShowUsers = [settingsStorage.accountName];

    noShowUsers.addAll(alreadyFlagged.map((e) => e.account));

    return FlagUserState(
      pageState: PageState.success,
      noShowUsers: noShowUsers,
    );
  }
}
