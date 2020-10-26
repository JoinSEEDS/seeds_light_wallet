import 'package:flutter/material.dart';
import 'package:seeds/models/firebase/guardian.dart';
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

    return buildGuardiansListView(myMembers, SettingsNotifier.of(context).accountName, myGuardians, () {
      // TODO: Not sure what we do here
    });
  }
}
