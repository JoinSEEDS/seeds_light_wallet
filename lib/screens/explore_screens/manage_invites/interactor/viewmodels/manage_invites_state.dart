import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/viewdata/InvitesItemsData.dart';

class ManageInvitesState extends Equatable {
  final PageState pageState;
  final List<InvitesItemsData> invitesItemData;
  final PageCommand? pageCommand;

  const ManageInvitesState({required this.pageState, required this.invitesItemData, this.pageCommand});

  Iterable<InvitesItemsData> get claimedInvites => invitesItemData.where((element) => element.invite.isClaimed);

  Iterable<InvitesItemsData> get unclaimedInvites => invitesItemData.where((element) => !element.invite.isClaimed);

  @override
  List<Object?> get props => [
        pageState,
        invitesItemData,
        pageCommand,
      ];

  ManageInvitesState copyWith({
    PageState? pageState,
    List<InvitesItemsData>? invitesItemData,
    PageCommand? pageCommand,
  }) {
    return ManageInvitesState(
      pageState: pageState ?? this.pageState,
      invitesItemData: invitesItemData ?? this.invitesItemData,
      pageCommand: pageCommand,
    );
  }

  factory ManageInvitesState.initial() {
    return const ManageInvitesState(
      pageState: PageState.initial,
      invitesItemData: [],
    );
  }
}
