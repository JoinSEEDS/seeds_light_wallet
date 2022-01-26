part of 'vouch_for_a_member_bloc.dart';

class VouchForAMemberState extends Equatable {
  final PageState pageState;
  final ProfileModel? selectedMember;
  final List<String> noShowUsers;
  final PageCommand? pageCommand;

  const VouchForAMemberState({
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

  VouchForAMemberState copyWith({
    PageState? pageState,
    ProfileModel? selectedMember,
    List<String>? noShowUsers,
    PageCommand? pageCommand,
  }) {
    return VouchForAMemberState(
      pageState: pageState ?? this.pageState,
      selectedMember: selectedMember ?? this.selectedMember,
      noShowUsers: noShowUsers ?? this.noShowUsers,
      pageCommand: pageCommand,
    );
  }

  factory VouchForAMemberState.initial(List<ProfileModel> alreadyVouched) {
    final List<String> noShowUsers = [settingsStorage.accountName];

    noShowUsers.addAll(alreadyVouched.map((e) => e.account));

    return VouchForAMemberState(
      pageState: PageState.success,
      noShowUsers: noShowUsers,
    );
  }
}
