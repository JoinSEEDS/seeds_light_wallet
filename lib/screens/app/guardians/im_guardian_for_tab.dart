

import 'package:flutter/material.dart';
import 'package:seeds/models/firebase/guardian.dart';
import 'package:seeds/models/firebase/guardian_status.dart';
import 'package:seeds/models/firebase/guardian_type.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/screens/app/guardians/my_guardians_tab.dart';

import 'guardian_user_tile.dart';

class ImGuardianForTab extends StatelessWidget {
  final List<Guardian> guardians;
  final List<MemberModel>? allMembers;

  ImGuardianForTab(this.guardians, this.allMembers);

  @override
  Widget build(BuildContext context) {
    List<Guardian> myGuardians = guardians.where((Guardian e) => e.type == GuardianType.imGuardian).toList();
    List<MemberModel> myMembers =
        allMembers!.where((item) => myGuardians.map((e) => e.uid).contains(item.account)).toList();

    //TODO: This is unused for now, This will be used in the near future.
    // ignore: unused_element
    _onTileTapped(MemberModel user, Guardian guardian) {
      if (guardian.recoveryStartedDate != null) {
        if (guardian.recoveryApprovedDate != null) {
          showRecoveryStartedBottomSheet(context, user);
        } else {
          showRecoveryStartedActionRequiredBottomSheet(context, user);
        }
      } else {
        if (guardian.status == GuardianStatus.alreadyGuardian) {
          showGuardianshipOptionsBottomSheet(context, user);
        }
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
                tileOnTap: () {}))
            .toList(),
      );
    }
  }

  void showGuardianshipOptionsBottomSheet(BuildContext context, MemberModel user) {
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
                  onPressed: () async {
                    print("List<QuerySnapshot> result");
                    var result =
                        await FirebaseDatabaseService().getMyAlreadyApprovedGuardiansForUserFuture(user.account);

                    if (result.docs.length >= MIN_GUARDIANS_COMPLETED) {
                      showStartRecoveryConfirmationDialog(user, context);
                    } else {
                      showNowEnoughGuardiansInfoDialog(user, context);
                    }
                  },
                  label: Text("Start Key Recovery"),
                  icon: Icon(Icons.vpn_key_sharp, color: Colors.grey),
                ),
                FlatButton.icon(
                  onPressed: () {
                    showRemoveGuardianshipConfirmationDialog(user, context);
                  },
                  label: Text(
                    "Remove Guardianship",
                    style: TextStyle(color: Colors.red),
                  ),
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                    "A motion to Recover ${user.nickname}'s Key has been initiated",
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
                    style: TextStyle(color: Colors.red),
                  ),
                  icon: Icon(Icons.cancel_rounded, color: Colors.red),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showRecoveryStartedActionRequiredBottomSheet(BuildContext context, MemberModel user) {
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
                    "A motion to Recover ${user.nickname}'s Key has been initiated",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  )),
                ),
                SizedBox(height: 20),
                FlatButton.icon(
                  onPressed: () {
                    FirebaseDatabaseService().approveRecoveryForUser(
                        friendId: user.account!, currentUserId: SettingsNotifier.of(context).accountName);
                    Navigator.pop(context);
                  },
                  label: Text(
                    "Approve this recovery",
                    style: TextStyle(color: Colors.green),
                  ),
                  icon: Icon(Icons.check_circle, color: Colors.green),
                ),
                FlatButton.icon(
                  onPressed: () {
                    showStopRecoveryConfirmationDialog(user, context);
                  },
                  label: Text(
                    "Stop this Recovery",
                    style: TextStyle(color: Colors.red),
                  ),
                  icon: Icon(Icons.cancel_rounded, color: Colors.red),
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
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Are you sure you want to stop key recovery process", style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Stop Key Recovery"),
              onPressed: () {
                FirebaseDatabaseService().stopRecoveryForUser(userId: user.account);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void showNowEnoughGuardiansInfoDialog(MemberModel user, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
              "User ${user.nickname} does not have the minimum required guardians. User must have at least 3 confirmed guardians",
              style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              child: const Text('Dismiss'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void showStartRecoveryConfirmationDialog(MemberModel user, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Are you sure you want to start key recovery process for ${user.nickname}?",
              style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              child: const Text('No: Dismiss'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Yes: Start Key Recovery", style: TextStyle(color: Colors.red)),
              onPressed: () {
                FirebaseDatabaseService().startRecoveryForUser(
                    userId: user.account, currentUserId: SettingsNotifier.of(context).accountName);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void showRemoveGuardianshipConfirmationDialog(MemberModel user, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Are you sure you want to stop being ${user.nickname}'s guardian?",
              style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              child: const Text('No: Dismiss'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text(
                "Yes: Remove Guardianship",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                FirebaseDatabaseService().removeImGuardianFor(
                    currentUserId: SettingsNotifier.of(context).accountName, friendId: user.account!);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
