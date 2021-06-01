import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/components/my_guardians_tab.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/guardians_bloc.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_events.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_state.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/page_commands.dart';

/// GuardiansScreen SCREEN
class GuardiansScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => GuardiansBloc(),
        child: BlocListener<GuardiansBloc, GuardiansState>(
            listenWhen: (_, state) => state.pageCommand != null,
            listener: (context, state) {
              var pageCommand = state.pageCommand;
              if (pageCommand is NavigateToSelectGuardians) {
                NavigationService.of(context).navigateTo(Routes.selectGuardians, pageCommand.myGuardians);
              }
            },
            child: BlocBuilder<GuardiansBloc, GuardiansState>(builder: (context, state) {
              return DefaultTabController(
                  length: 2,
                  child: Scaffold(
                      floatingActionButton: FloatingActionButton.extended(
                        label: const Text("Add Guardians"),
                        onPressed: () {
                          BlocProvider.of<GuardiansBloc>(context).add(OnAddGuardiansTapped());
                        },
                      ),
                      appBar: AppBar(
                        bottom: const TabBar(
                          tabs: [
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text("My Guardians"),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text("Im Guardian For"),
                            )
                          ],
                        ),
                        automaticallyImplyLeading: true,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        title: const Text("Key Guardians"),
                        centerTitle: true,
                      ),
                      body: TabBarView(
                        children: [
                          MyGuardiansTab(),
                          MyGuardiansTab(),
                        ],
                      )));
            })));
  }
}
