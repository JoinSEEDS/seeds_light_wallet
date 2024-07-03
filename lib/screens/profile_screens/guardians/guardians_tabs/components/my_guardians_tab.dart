import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_status.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_type.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/i18n/profile_screens/guardians/guardians.i18n.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/components/my_guardian_list_widget.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/components/no_guardian_widget.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_bloc.dart';

class MyGuardiansTab extends StatelessWidget {
  const MyGuardiansTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<GuardianModel>>(
        stream: BlocProvider.of<GuardiansBloc>(context).guardians,
        builder: (context, AsyncSnapshot<List<GuardianModel>> snapshot) {
          if (snapshot.hasData) {
            final myGuardians = snapshot.data!.where((element) => element.type == GuardianType.myGuardian);
            final alreadyGuardians = myGuardians.where((element) => element.status == GuardianStatus.alreadyGuardian);

            if (myGuardians.isEmpty) {
              return NoGuardiansWidget(
                message:
                    "You have added no user to become your guardian yet. Once you do, the request will show here.".i18n,
              );
            } else {
              final List<Widget> items = [];

              items.add(StreamBuilder<bool>(
                  stream: BlocProvider.of<GuardiansBloc>(context).isGuardianContractInitialized,
                  builder: (context, isGuardiansInitialized) {
                    if (shouldShowReadyToActivateGuardiansButton(isGuardiansInitialized, alreadyGuardians)) {
                      return Center(
                          child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: MaterialButton(
                          color: AppColors.green1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          onPressed: () {
                            BlocProvider.of<GuardiansBloc>(context).add(OnGuardianReadyForActivation(myGuardians));
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [Text("Activate "), Icon(Icons.shield), Text(" Guardians")],
                          ),
                        ),
                      ));
                    } else {
                      return const SizedBox.shrink();
                    }
                  }));

              items.add(Expanded(
                  child: MyGuardiansListWidget(
                currentUserId: settingsStorage.accountName,
                guardians: myGuardians.toList(),
              )));

              if (alreadyGuardians.length < 3) {
                items.add(
                  Padding(
                    padding: const EdgeInsets.only(left: 56.0, right: 56, top: 16, bottom: 20),
                    child: Center(
                      child: Text(
                        "IMPORTANT: You need a minimum of 3 Guardians to secure your backup key".i18n,
                        style: Theme.of(context).textTheme.subtitle3Red,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              } else {
                items.add(StreamBuilder<bool>(
                    stream: BlocProvider.of<GuardiansBloc>(context).isGuardianContractInitialized,
                    builder: (context, isGuardiansInitialized) {
                      if (isGuardiansInitialized.hasData && isGuardiansInitialized.data!) {
                        return Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text("Your guardians are active!".i18n),
                        );
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

  bool shouldShowReadyToActivateGuardiansButton(
      AsyncSnapshot<bool> isGuardiansInitialized, Iterable<GuardianModel> alreadyGuardians) {
    return isGuardiansInitialized.hasData && !isGuardiansInitialized.data! && alreadyGuardians.length >= 3;
  }
}
