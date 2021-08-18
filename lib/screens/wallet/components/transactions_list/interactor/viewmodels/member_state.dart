import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_state.dart';

class MemberState extends Equatable {
  final PageState pageState;
  final String accountName;
  final MemberModel? member;

  String get displayName => (member != null && member!.nickname.isNotEmpty) ? member!.nickname : accountName;
  String get profileImageURL => member?.image ?? "";

  const MemberState({required this.pageState, required this.accountName, this.member});

  @override
  List<Object> get props => [pageState, accountName];

  MemberState copyWith({PageState? pageState, String? accountName, MemberModel? member}) {
    return MemberState(
      pageState: pageState ?? this.pageState,
      accountName: accountName ?? this.accountName,
      member: member ?? this.member,
    );
  }

  factory MemberState.initial(String accountName) {
    return MemberState(pageState: PageState.initial, accountName: accountName);
  }
}
