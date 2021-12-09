part of 'vouch_for_a_member_bloc.dart';

class VouchForAMemberState extends Equatable {
  final PageState pageState;
  final Set<MemberModel> selectedMember;
  final List<String> noShowUsers;

  const VouchForAMemberState({
    required this.pageState,
    required this.selectedMember,
    required this.noShowUsers,
  });

  @override
  List<Object?> get props => [
        pageState,
        selectedMember,
        noShowUsers,
      ];

  VouchForAMemberState copyWith({
    PageState? pageState,
    Set<MemberModel>? selectedMember,
    List<String>? noShowUsers,
  }) {
    return VouchForAMemberState(
      pageState: pageState ?? this.pageState,
      selectedMember: selectedMember ?? this.selectedMember,
      noShowUsers: noShowUsers ?? this.noShowUsers,
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
