part of 'vouch_for_a_member_bloc.dart';

class VouchForAMemberState extends Equatable {
  final PageState pageState;
  final Set<MemberModel> selectedMember;
  final List<String> noShowUsers;
  final PageCommand? pageCommand;

  const VouchForAMemberState({
    required this.pageState,
    required this.selectedMember,
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
    Set<MemberModel>? selectedMember,
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

  factory VouchForAMemberState.initial() {
    final List<String> noShowUsers = [settingsStorage.accountName];

    return VouchForAMemberState(
      pageState: PageState.success,
      selectedMember: {},
      noShowUsers: noShowUsers,
    );
  }
}
