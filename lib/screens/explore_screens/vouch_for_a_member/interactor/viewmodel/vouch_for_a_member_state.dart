part of 'vouch_for_a_member_bloc.dart';

class VouchForAMemberState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final MemberModel? selectedMember;
  final List<String> noShowUsers;
  final PageCommand? pageCommand;

  const VouchForAMemberState({
    required this.pageState,
    this.errorMessage,
    this.selectedMember,
    required this.noShowUsers,
    this.pageCommand,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        selectedMember,
        noShowUsers,
        pageCommand,
      ];

  VouchForAMemberState copyWith({
    PageState? pageState,
    String? errorMessage,
    MemberModel? selectedMember,
    List<String>? noShowUsers,
    PageCommand? pageCommand,
  }) {
    return VouchForAMemberState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      selectedMember: selectedMember ?? this.selectedMember,
      noShowUsers: noShowUsers ?? this.noShowUsers,
      pageCommand: pageCommand,
    );
  }

  factory VouchForAMemberState.initial(List<MemberModel> alreadyVouched) {
    final List<String> noShowUsers = [settingsStorage.accountName];

    for (int i = 0; i < alreadyVouched.length; i++) {
      final element = alreadyVouched[i];
      noShowUsers.add(element.account);
    }

    return VouchForAMemberState(
      pageState: PageState.success,
      noShowUsers: noShowUsers,
    );
  }
}
