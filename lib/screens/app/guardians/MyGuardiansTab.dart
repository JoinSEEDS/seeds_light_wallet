import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seeds/models/firebase/GuardianStatus.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/screens/shared/guardian_user_tile.dart';
import 'package:seeds/screens/shared/user_tile.dart';

class MyGuardiansTab extends StatefulWidget {
  final List<MemberModel> members;

  MyGuardiansTab(this.members);

  @override
  State<StatefulWidget> createState() {
    return _MyGuardiansState();
  }
}

class _MyGuardiansState extends State<MyGuardiansTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseDatabaseService().getMyGuardians(SettingsNotifier.of(context).accountName),
        builder: (context, guardSnaps) {
          if (guardSnaps.hasData) {
            Iterable<String> users = guardSnaps.data.docs.map((e) => e.id);
            Iterable<MemberModel> filteredList = widget.members.where((item) => users.contains(item.account));

            return ListView(
              children: filteredList
                  .map((e) => guardianUserTile(
                      user: e,
                      status: fromName(guardSnaps.data.docs.firstWhere((element) => element.id == e.account)["status"]),
                      onTap: () {}))
                  .toList(),
            );
          } else {
            return SizedBox.shrink();
          }
        });
  }
}
