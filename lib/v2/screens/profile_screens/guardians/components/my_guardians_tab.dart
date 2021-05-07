import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_status.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_type.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/components/guardian_row.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/interactor/guardians_bloc.dart';

class MyGuardiansTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<GuardianModel>>(
        stream: BlocProvider.of<GuardiansBloc>(context).guardians,
        builder: (context, AsyncSnapshot<List<GuardianModel>> snapshot) {
          if (snapshot.hasData) {
            var myGuardians = snapshot.data!.where((element) => element.type == GuardianType.myGuardian);

            if (myGuardians.isEmpty) {
              return NoGuardiansWidget();
            } else {
              List<Widget> items = [];

              items.add(Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: MyGuardiansListWidget(
                  currentUserId: settingsStorage.accountName,
                  guardians: myGuardians.toList(),
                ),
              )));

              if (myGuardians.length < 3) {
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
                          return const SizedBox.shrink();
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: FlatButtonLong(
                              title: "Activate My Guardians",
                              onPressed: () {
                                // GuardianServices()
                                //     .initGuardians(service, accountName)
                                //     .then((value) => onInitGuardianResponse(value))
                                //     .catchError((onError) => onInitGuardianError(onError));
                              },
                            ),
                          );
                        }
                      } else {
                        return const SizedBox.shrink();
                      }
                    }));
              }

              return Column(children: items);
            }
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}

class NoGuardiansWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(32.0),
      child: Text(
        "You have added no user to become your guardian yet. Once you do, the request will show here.",
        style: Theme.of(context).textTheme.subtitle2LowEmphasis,
      ),
    ));
  }
}

class MyGuardiansListWidget extends StatelessWidget {
  final String currentUserId;
  final List<GuardianModel> guardians;

  const MyGuardiansListWidget({Key? key, required this.currentUserId, required this.guardians}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: guardians.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const SizedBox.shrink();
          }

          var guardian = guardians[index - 1];

          return GuardianRow(
            account: guardian.uid,
            imageUrl: guardian.image,
            name: guardian.nickname,
          );
        },
        separatorBuilder: (context, index) {
          return GuardianListSeparatorWidget(guardians: guardians, index: index);
        });
  }
}

class GuardianListSeparatorWidget extends StatelessWidget {
  final int index;
  final List<GuardianModel> guardians;

  const GuardianListSeparatorWidget({Key? key, required this.index, required this.guardians}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var requested = Container(
      child: const Padding(
        padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
        child: Center(child: Text("Requested")),
      ),
    );

    if (index == 0) {
      var guardian = guardians[index];
      if (guardian.status == GuardianStatus.alreadyGuardian) {
        return Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            child: Center(
              child: Text(
                "My Guardians",
                style: Theme.of(context).textTheme.subtitle2HighEmphasis,
              ),
            ),
          ),
        );
      } else {
        return requested;
      }
    } else if (index > guardians.length - 1) {
      return const SizedBox.shrink();
    } else {
      var guardian = guardians[index - 1];
      var next = guardians[index];

      if (guardian.status != next.status) {
        return requested;
      } else {
        return const SizedBox.shrink();
      }
    }
  }
}
