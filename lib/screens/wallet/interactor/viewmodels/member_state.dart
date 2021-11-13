part of 'member_bloc.dart';

class MemberState extends Equatable {
  final PageState pageState;
  final String currentAccount;
  final MemberModel? member;

  String get displayName => (member != null && member!.nickname.isNotEmpty) ? member!.nickname : currentAccount;
  String get profileImageURL => member?.image ?? "";

  const MemberState({required this.pageState, required this.currentAccount, this.member});

  @override
  List<Object> get props => [pageState, currentAccount];

  MemberState copyWith({PageState? pageState, String? currentAccount, MemberModel? member}) {
    return MemberState(
      pageState: pageState ?? this.pageState,
      currentAccount: currentAccount ?? this.currentAccount,
      member: member ?? this.member,
    );
  }

  factory MemberState.initial(String currentAccount) {
    return MemberState(pageState: PageState.initial, currentAccount: currentAccount);
  }
}
