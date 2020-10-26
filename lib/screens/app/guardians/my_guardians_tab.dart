import 'package:flutter/material.dart';
import 'package:seeds/models/firebase/guardian.dart';
import 'package:seeds/models/firebase/guardian_status.dart';
import 'package:seeds/models/firebase/guardian_type.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/screens/app/guardians/guardian_users_list.dart';

class MyGuardiansTab extends StatelessWidget {
  final List<Guardian> guardians;
  final List<MemberModel> allMembers;

  MyGuardiansTab(this.guardians, this.allMembers);

  @override
  Widget build(BuildContext context) {
    var myGuardians = guardians.where((Guardian e) => e.type == GuardianType.myGuardian).toList();
    var myMembers = allMembers.where((item) => myGuardians.map((e) => e.uid).contains(item.account)).toList();

    _onTileTapped(MemberModel user, GuardianStatus status) {
      List<Widget> action = <Widget>[];

      if (status == GuardianStatus.alreadyGuardian) {
        action = [
          FlatButton(
            child: const Text('Dismiss'),
            onPressed: () {},
          ),
          FlatButton(
            child: const Text('Remove Guardian', style: TextStyle(color: Colors.red)),
            onPressed: () {},
          )
        ];

        showDialog(
            context: context,
            child: AlertDialog(
              content: Text("Guardian ${user.nickname}"),
              actions: action,
            ));
      }
    }

    return buildGuardiansListView(myMembers, SettingsNotifier.of(context).accountName, myGuardians, _onTileTapped);
  }
}
