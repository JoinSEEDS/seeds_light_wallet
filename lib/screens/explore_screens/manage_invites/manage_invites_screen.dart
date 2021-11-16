import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/snack_bar_info.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/i18n/profile_screens/guardians/guardians.i18n.dart';
import 'package:seeds/screens/explore_screens/manage_invites/components/claimed_invite_row.dart';
import 'package:seeds/screens/explore_screens/manage_invites/components/unclaimed_invite_row.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/manage_invites_bloc.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/viewdata/InvitesItemsData.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/viewmodels/manage_invites_events.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/viewmodels/manage_invites_state.dart';

/// manage Invites SCREEN
class ManageInvitesScreen extends StatelessWidget {
  const ManageInvitesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ManageInvitesBloc()..add(LoadInvites()),
        child: BlocConsumer<ManageInvitesBloc, ManageInvitesState>(listener: (context, state) {
          final pageCommand = state.pageCommand;
          if (pageCommand is ShowErrorMessage) {
            SnackBarInfo(pageCommand.message, ScaffoldMessenger.of(context)).show();
          } else if (pageCommand is ShowMessage) {
            SnackBarInfo(pageCommand.message, ScaffoldMessenger.of(context)).show();
          }
        }, builder: (context, state) {
          return DefaultTabController(
              length: 2,
              child: SafeArea(
                top: false,
                child: Scaffold(
                    appBar: AppBar(
                      bottom: TabBar(
                        tabs: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(state.claimedTabTitle),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(state.unClaimedTabTitle),
                          )
                        ],
                      ),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      title: Text("Manage Invites".i18n),
                    ),
                    body: state.pageState == PageState.loading
                        ? const FullPageLoadingIndicator()
                        : TabBarView(
                            children: [
                              if (state.claimedInvites.isNotEmpty)
                                ListView(
                                  children: state.claimedInvites
                                      .map((InvitesItemsData invite) => ClaimedInviteRow(
                                            account: invite.invite.account!,
                                            name: invite.profileModel?.nickname,
                                            imageUrl: invite.profileModel?.image,
                                            status: invite.profileModel?.status,
                                          ))
                                      .toList(),
                                )
                              else
                                const Center(child: Text("You have no claimed invitations.")),
                              if (state.unclaimedInvites.isNotEmpty)
                                ListView(
                                  children: state.unclaimedInvites
                                      .map((InvitesItemsData invite) => UnClaimedInviteRow(
                                            amount: invite.invite.seedsFormattedInviteTotalAmount,
                                            inviteHex: invite.invite.inviteHash,
                                            cancelCallback: () {
                                              BlocProvider.of<ManageInvitesBloc>(context)
                                                  .add(OnCancelInviteTapped(invite.invite.inviteHash));
                                            },
                                          ))
                                      .toList(),
                                )
                              else
                                const Center(child: Text("You have no unclaimed invitations.")),
                            ],
                          )),
              ));
        }));
  }
}
