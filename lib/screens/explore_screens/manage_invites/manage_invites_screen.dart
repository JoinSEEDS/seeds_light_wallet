import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/i18n/profile_screens/guardians/guardians.i18n.dart';
import 'package:seeds/screens/explore_screens/manage_invites/components/claimed_invite_row.dart';
import 'package:seeds/screens/explore_screens/manage_invites/components/unclaimed_invite_row.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/viewmodels/manage_invites_bloc.dart';

class ManageInvitesScreen extends StatelessWidget {
  const ManageInvitesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ManageInvitesBloc()..add(const OnLoadInvites()),
      child: BlocConsumer<ManageInvitesBloc, ManageInvitesState>(
        listener: (context, state) {
          final pageCommand = state.pageCommand;
          if (pageCommand is ShowErrorMessage) {
            eventBus.fire(ShowSnackBar(pageCommand.message));
          } else if (pageCommand is ShowMessage) {
            eventBus.fire(ShowSnackBar(pageCommand.message));
          }
        },
        builder: (context, state) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text("Manage Invites".i18n),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                bottom: TabBar(
                  tabs: [
                    Padding(padding: const EdgeInsets.all(16.0), child: Text(state.claimedTabTitle)),
                    Padding(padding: const EdgeInsets.all(16.0), child: Text(state.unClaimedTabTitle))
                  ],
                ),
              ),
              body: SafeArea(
                child: state.pageState == PageState.loading
                    ? const FullPageLoadingIndicator()
                    : TabBarView(
                        children: [
                          if (state.claimedInvites.isNotEmpty)
                            ListView(
                              children: [
                                for (final i in state.claimedInvites)
                                  ClaimedInviteRow(
                                    account: i.invite.account!,
                                    name: i.profileModel?.nickname,
                                    imageUrl: i.profileModel?.image,
                                    status: i.profileModel?.status,
                                  ),
                              ],
                            )
                          else
                            const Center(child: Text("You have no claimed invitations.")),
                          if (state.unclaimedInvites.isNotEmpty)
                            ListView(
                              children: [
                                for (final i in state.unclaimedInvites)
                                  UnClaimedInviteRow(
                                    amount: i.invite.seedsFormattedInviteTotalAmount,
                                    inviteHex: i.invite.inviteHash,
                                    cancelCallback: () {
                                      BlocProvider.of<ManageInvitesBloc>(context)
                                          .add(OnCancelInviteTapped(i.invite.inviteHash));
                                    },
                                  ),
                              ],
                            )
                          else
                            const Center(child: Text("You have no unclaimed invitations.")),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
