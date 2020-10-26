import 'package:flutter/material.dart';
import 'package:seeds/models/firebase/guardian.dart';
import 'package:seeds/models/firebase/guardian_status.dart';
import 'package:seeds/models/firebase/guardian_type.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/screens/app/guardians/guardian_users_list.dart';

class ImGuardianForTab extends StatelessWidget {
  final List<Guardian> guardians;
  final List<MemberModel> allMembers;

  ImGuardianForTab(this.guardians, this.allMembers);

  @override
  Widget build(BuildContext context) {
    var myGuardians = guardians.where((Guardian e) => e.type == GuardianType.imGuardian).toList();
    var myMembers = allMembers.where((item) => myGuardians.map((e) => e.uid).contains(item.account)).toList();

    _onTileTapped(MemberModel user, GuardianStatus status) {
      if (status == GuardianStatus.alreadyGuardian) {
        showDialog(
            context: context,
            child: AlertDialog(content: Text("Guardian ${user.nickname}"), actions: [
              FlatButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: const Text('Remove Guardian', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  //TODO
                },
              )
            ]));
      }
    }

    return buildGuardiansListView(myMembers, SettingsNotifier.of(context).accountName, myGuardians, _onTileTapped);
  }
}
