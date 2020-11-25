import 'package:flutter/material.dart';
import 'package:seeds/models/firebase/guardian.dart';
import 'package:seeds/models/firebase/guardian_status.dart';
import 'package:seeds/models/firebase/guardian_type.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/screens/app/guardians/my_guardian_users_list.dart';

const MIN_GUARDIANS_COMPLETED = 3;

class MyGuardiansTab extends StatelessWidget {
  final List<Guardian> guardians;
  final List<MemberModel> allMembers;

  MyGuardiansTab(this.guardians, this.allMembers);

  @override
  Widget build(BuildContext context) {
    var myGuardians = guardians.where((Guardian e) => e.type == GuardianType.myGuardian).toList();
    var myMembers = allMembers.where((item) => myGuardians.map((e) => e.uid).contains(item.account)).toList();

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
            FlatButton(
              child: const Text('Remove Guardian', style: TextStyle(color: Colors.red)),
              onPressed: () {
                FirebaseDatabaseService().removeMyGuardian(
                    currentUserId: SettingsNotifier.of(context).accountName, friendId: user.account);
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
                  icon: Icon(Icons.cancel_rounded, color: Colors.blue),
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
                  FirebaseDatabaseService()
                      .stopRecoveryForUser(userId: SettingsNotifier.of(context).accountName);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ]));
  }
}
