import 'package:flutter/material.dart';
import 'package:seeds/models/firebase/guardian.dart';
import 'package:seeds/models/firebase/guardian_status.dart';
import 'package:seeds/models/firebase/guardian_type.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';

import 'guardian_user_tile.dart';

class ImGuardianForTab extends StatelessWidget {
  final List<Guardian> guardians;
  final List<MemberModel> allMembers;

  ImGuardianForTab(this.guardians, this.allMembers);

  @override
  Widget build(BuildContext context) {
    var myGuardians = guardians.where((Guardian e) => e.type == GuardianType.imGuardian).toList();
    var myMembers = allMembers.where((item) => myGuardians.map((e) => e.uid).contains(item.account)).toList();

    _onTileTapped(MemberModel user, Guardian guardian) {
      if (guardian.status == GuardianStatus.alreadyGuardian) {
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
                    Center(
                        child: Text(
                      "I am Guardian for ${user.nickname}",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )),
                    SizedBox(height: 20),
                    FlatButton.icon(
                      onPressed: () {
                        showStartRecoveryConfirmationDialog(user, context);
                      },
                      label: Text("Start Key Recovery"),
                      icon: Icon(Icons.vpn_key_sharp, color: Colors.grey),
                    ),
                    FlatButton.icon(
                      onPressed: () {
                        showRemoveGuardianshipConfirmationDialog(user, context);
                      },
                      label: Text("Remove Guardianship"),
                      icon: Icon(Icons.delete, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    }

    if (myMembers.isEmpty) {
      return Center(
          child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text(
            "No users have added you to become their guardian yet. Once they do, you will see their request here."),
      ));
    } else {
      return ListView(
        children: myMembers
            .map((e) => guardianUserTile(
                user: e,
                currentUserId: SettingsNotifier.of(context).accountName,
                guardian: myGuardians.firstWhere((element) => element.uid == e.account),
                tileOnTap: _onTileTapped))
            .toList(),
      );
    }
  }

  void showStartRecoveryConfirmationDialog(MemberModel user, BuildContext context) {
    showDialog(
        context: context,
        child: AlertDialog(
            content: Text("Are you sure you want to start key recovery process for ${user.nickname}?",
                style: TextStyle(color: Colors.black)),
            actions: [
              FlatButton(
                child: const Text('No: Dismiss'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Yes: Start Key Recovery", style: TextStyle(color: Colors.red)),
                onPressed: () {
                  FirebaseDatabaseService().startRecoveryForUser(
                      currentUserId: SettingsNotifier.of(context).accountName, account: user.account);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ]));
  }

  void showRemoveGuardianshipConfirmationDialog(MemberModel user, BuildContext context) {
    showDialog(
        context: context,
        child: AlertDialog(
            content: Text("Are you sure you want to stop being ${user.nickname}'s guardian?",
                style: TextStyle(color: Colors.black)),
            actions: [
              FlatButton(
                child: const Text('No: Dismiss'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: const Text(
                  "Yes: Remove Guardianship",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  FirebaseDatabaseService().removeImGuardianFor(
                      currentUserId: SettingsNotifier.of(context).accountName, friendId: user.account);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ]));
  }
}
