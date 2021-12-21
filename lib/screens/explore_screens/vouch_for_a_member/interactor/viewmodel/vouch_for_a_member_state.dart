part of 'vouch_for_a_member_bloc.dart';

class VouchForAMemberState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final MemberModel? selectedMember;
  final Set<String> noShowUsers;
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
    Set<String>? noShowUsers,
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

  factory VouchForAMemberState.initial() {
    final Set<String> noShowUsers = {settingsStorage.accountName};

    return VouchForAMemberState(
      pageState: PageState.success,
      noShowUsers: noShowUsers,
    );
  }
}
