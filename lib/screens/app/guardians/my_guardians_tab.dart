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

    _onTileTapped(MemberModel user, GuardianStatus status) {
      if (status == GuardianStatus.alreadyGuardian) {
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
    }

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
        child:
            buildMyGuardiansListView(myMembers, SettingsNotifier.of(context).accountName, myGuardians, _onTileTapped)));

    return Column(children: items);
  }
}
