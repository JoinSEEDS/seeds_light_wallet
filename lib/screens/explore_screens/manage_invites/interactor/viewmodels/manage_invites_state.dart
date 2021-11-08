import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/viewdata/InvitesItemsData.dart';

class ManageInvitesState extends Equatable {
  final PageState pageState;
  final List<InvitesItemsData> invitesItemData;

  const ManageInvitesState({required this.pageState, required this.invitesItemData});

  Iterable<InvitesItemsData> get claimedInvites => invitesItemData.where((element) => element.invite.isClaimed);

  Iterable<InvitesItemsData> get unclaimedInvites => invitesItemData.where((element) => !element.invite.isClaimed);

  @override
  List<Object?> get props => [
        pageState,
        invitesItemData,
      ];

  ManageInvitesState copyWith({
    PageState? pageState,
    List<InvitesItemsData>? invitesItemData,
  }) {
    return ManageInvitesState(
      pageState: pageState ?? this.pageState,
      invitesItemData: invitesItemData ?? this.invitesItemData,
    );
  }

  factory ManageInvitesState.initial() {
    return const ManageInvitesState(
      pageState: PageState.initial,
      invitesItemData: [],
    );
  }
}
