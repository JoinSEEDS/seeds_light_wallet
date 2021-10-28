import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/i18n/profile_screens/guardians/guardians.i18n.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/manage_invites_bloc.dart';
import 'package:seeds/screens/explore_screens/manage_invites/interactor/viewmodels/manage_invites_state.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/components/im_guardian_for_tab.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/components/my_guardians_tab.dart';

/// manage Invites SCREEN
class ManageInvitesScreen extends StatelessWidget {
  const ManageInvitesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ManageInvitesBloc(),
        child: BlocBuilder<ManageInvitesBloc, ManageInvitesState>(builder: (context, state) {
          return DefaultTabController(
              length: 2,
              child: Scaffold(
                  floatingActionButton: state.pageState == PageState.loading
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(left: 32),
                          child: FlatButtonLong(
                            title: "Create Invite",
                            onPressed: () {
                              // BlocProvider.of<ManageInvitesBloc>(context).add(OnAddGuardiansTapped());
                            },
                          )),
                  appBar: AppBar(
                    bottom: const TabBar(
                      tabs: [
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Claimed Invites"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Unclaimed Invites"),
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
                      : const TabBarView(
                          children: [
                            MyGuardiansTab(),
                            ImGuardianForTab(),
                          ],
                        )));
        }));
  }
}
