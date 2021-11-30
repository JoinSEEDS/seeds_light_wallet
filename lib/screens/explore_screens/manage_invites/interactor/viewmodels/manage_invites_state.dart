part of 'manage_invites_bloc.dart';

class ManageInvitesState extends Equatable {
  final PageState pageState;
  final List<InvitesItemsData> invitesItemData;
  final PageCommand? pageCommand;

  const ManageInvitesState({required this.pageState, required this.invitesItemData, this.pageCommand});

  Iterable<InvitesItemsData> get claimedInvites => invitesItemData.where((element) => element.invite.isClaimed);

  Iterable<InvitesItemsData> get unclaimedInvites => invitesItemData.where((element) => !element.invite.isClaimed);

  String get claimedTabTitle => "Claimed Invites${claimedInvites.isNotEmpty ? " (${claimedInvites.length})" : ""}";

  String get unClaimedTabTitle =>
      "Unclaimed Invites${unclaimedInvites.isNotEmpty ? " (${unclaimedInvites.length})" : ""}";

  @override
  List<Object?> get props => [pageState, invitesItemData, pageCommand];

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
