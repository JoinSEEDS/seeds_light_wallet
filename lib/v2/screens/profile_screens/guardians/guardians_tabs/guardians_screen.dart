import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/components/my_guardians_tab.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/guardians_bloc.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_events.dart';

/// GuardiansScreen SCREEN
class GuardiansScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GuardiansBloc()..add(LoadGuardians(userName: SettingsNotifier.of(context).accountName)),
      child: DefaultTabController(
          length: 2,
          child: Scaffold(
              floatingActionButton: FloatingActionButton.extended(
                label: const Text("Add Guardians"),
                onPressed: () {

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
                      child: Text(
                        "Im Guardian For",
                      ),
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
              ))),
    );
  }
}
