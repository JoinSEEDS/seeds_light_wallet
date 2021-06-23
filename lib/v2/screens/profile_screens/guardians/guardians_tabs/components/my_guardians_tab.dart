import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_status.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_type.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/components/my_guardian_list_widget.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/components/no_guardian_widget.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/guardians_bloc.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_events.dart';

class MyGuardiansTab extends StatelessWidget {
  const MyGuardiansTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<GuardianModel>>(
        stream: BlocProvider.of<GuardiansBloc>(context).guardians,
        builder: (context, AsyncSnapshot<List<GuardianModel>> snapshot) {
          if (snapshot.hasData) {
            var myGuardians = snapshot.data!.where((element) => element.type == GuardianType.myGuardian);
            var alreadyGuardians = myGuardians.where((element) => element.status == GuardianStatus.alreadyGuardian);

            if (myGuardians.isEmpty) {
              return const NoGuardiansWidget(
                message: "You have added no user to become your guardian yet. Once you do, the request will show here.",
              );
            } else {
              List<Widget> items = [];

              items.add(Expanded(
                  child: MyGuardiansListWidget(
                currentUserId: settingsStorage.accountName,
                guardians: myGuardians.toList(),
              )));

              if (alreadyGuardians.length < 3) {
                items.add(Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 56.0, right: 56, top: 16, bottom: 100),
                    child: Center(
                      child: Text(
                        "IMPORTANT: You need a minimum of 3 Guardians to secure your backup key",
                        style: Theme.of(context).textTheme.subtitle3Red,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ));
              } else {
                items.add(StreamBuilder<bool>(
                    stream: BlocProvider.of<GuardiansBloc>(context).isGuardianContractInitialized,
                    builder: (context, isGuardiansInitialized) {
                      if (isGuardiansInitialized.hasData) {
                        if (isGuardiansInitialized.data!) {
                          return const Padding(
                            padding: EdgeInsets.all(24),
                            child: Text("Your guardians are active!"),
                          );
                        } else {
                          BlocProvider.of<GuardiansBloc>(context).add(OnGuardianReadyForActivation(myGuardians));

                          return const SizedBox.shrink();
                        }
                      } else {
                        return const SizedBox.shrink();
                      }
                    }));
              }

              return Column(children: items);
            }
          } else {
            return const FullPageLoadingIndicator();
          }
        });
  }
}
