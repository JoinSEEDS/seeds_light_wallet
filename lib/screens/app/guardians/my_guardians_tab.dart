import 'package:flutter/material.dart';
import 'package:flutter_toolbox/flutter_toolbox.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/models/firebase/guardian.dart';
import 'package:seeds/models/firebase/guardian_status.dart';
import 'package:seeds/models/firebase/guardian_type.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/providers/services/guardian_services.dart';
import 'package:seeds/screens/app/guardians/my_guardian_users_list.dart';
import 'package:seeds/widgets/main_button.dart';

const MIN_GUARDIANS_COMPLETED = 3;

class MyGuardiansTab extends StatefulWidget {
  final List<Guardian> guardians;
  final List<MemberModel> allMembers;

  MyGuardiansTab(this.guardians, this.allMembers);

  @override
  _MyGuardiansTabState createState() => _MyGuardiansTabState();
}

class _MyGuardiansTabState extends State<MyGuardiansTab> {
  final removeGuardianLoader = GlobalKey<MainButtonState>();
  final activateGuardiansLoader = GlobalKey<MainButtonState>();

  @override
  Widget build(BuildContext context) {
    var myGuardians = widget.guardians.where((Guardian e) => e.type == GuardianType.myGuardian).toList();
    var myMembers = widget.allMembers.where((item) => myGuardians.map((e) => e.uid).contains(item.account)).toList();

    _onTileTapped(MemberModel user, Guardian guardian) {
      if (guardian.recoveryStartedDate != null) {
        showRecoveryStartedBottomSheet(context, user);
      } else {
        if (guardian.status == GuardianStatus.alreadyGuardian) {
          showGuardianOptionsDialog(context, user);
        }
      }
    }

    if (myMembers.isEmpty) {
      return Center(
          child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text("You have added no user to become your guardian yet. Once you do, the request will show here."),
      ));
    } else {
      List<Widget> items = [];
      if (myGuardians.where((element) => element.status == GuardianStatus.alreadyGuardian).length < 3) {
        items.add(Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                "IMPORTANT: You need a minimum of 3 Guardians to secure your backup key",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ),
        ));
      } else {
        var service = EosService.of(context);
        var accountName = SettingsNotifier.of(context).accountName;

        items.add(StreamBuilder<bool>(
            stream: FirebaseDatabaseService().isGuardiansInitialized(accountName),
            builder: (context, isGuardiansInitialized) {
              if (isGuardiansInitialized.hasData) {
                if (isGuardiansInitialized.data) {
                  return SizedBox.shrink();
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MainButton(
                      title: "Activate My Guardians",
                      key: activateGuardiansLoader,
                      onPressed: () {
                        setState(() {
                          activateGuardiansLoader.currentState.loading();
                        });

                        GuardianServices()
                            .initGuardians(service, accountName)
                            .catchError((onError) => print("Error " + onError.toString()))
                            .then((value) => onInitGuardianResponse(value));
                      },
                    ),
                  );
                }
              } else {
                return SizedBox.shrink();
              }
            }));
      }

      items.add(Expanded(
          child: buildMyGuardiansListView(
              myMembers, SettingsNotifier.of(context).accountName, myGuardians, _onTileTapped)));

      return Column(children: items);
    }
  }

  void showGuardianOptionsDialog(BuildContext context, MemberModel user) {
    showDialog(
        context: context,
        child: AlertDialog(
          content: Text("Guardian ${user.nickname}"),
          actions: [
            FlatButton(
              child: const Text('Dismiss'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            MainButton(
              title: 'Remove Guardian',
              key: removeGuardianLoader,
              onPressed: () async {
                setState(() {
                  removeGuardianLoader.currentState.loading();
                });

                await FirebaseDatabaseService().removeMyGuardian(currentUserId: SettingsNotifier.of(context).accountName, friendId: user.account);

                // GuardianServices()
                //     .removeGuardian(EosService.of(context), SettingsNotifier.of(context).accountName, user.account);

                setState(() {
                  removeGuardianLoader.currentState.done();
                });

                Navigator.pop(context);
              },
            )
          ],
        ));
  }

  void showRecoveryStartedBottomSheet(BuildContext context, MemberModel user) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Container(
                    child: SizedBox(height: 2, width: 40),
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Center(
                      child: Text(
                    "A motion to Recover your Key has been initiated by ${user.nickname}",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  )),
                ),
                SizedBox(height: 20),
                FlatButton.icon(
                  onPressed: () {
                    showStopRecoveryConfirmationDialog(user, context);
                  },
                  label: Text(
                    "Stop this Recovery",
                    style: TextStyle(color: Colors.blue),
                  ),
                  icon: Icon(Icons.cancel_rounded, color: AppColors.blue),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showStopRecoveryConfirmationDialog(MemberModel user, BuildContext context) {
    showDialog(
        context: context,
        child: AlertDialog(
            content: Text("Are you sure you want to stop key recovery process", style: TextStyle(color: Colors.black)),
            actions: [
              FlatButton(
                child: const Text('No: Dismiss'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Yes: Stop Key Recovery"),
                onPressed: () {
                  FirebaseDatabaseService().stopRecoveryForUser(userId: SettingsNotifier.of(context).accountName);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ]));
  }

  onInitGuardianResponse(value) {
    // There was an error
    if (value == null) {
      print("onInitGuardianResponse null");
      errorToast('Oops, Something went wrong');
    } else {
      print("onInitGuardianResponse " + value.toString());
      successToast('Success, Guardians are now Active');
    }

    setState(() {
      activateGuardiansLoader.currentState.done();
    });
  }
}
