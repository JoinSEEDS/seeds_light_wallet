import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seeds/models/firebase/guardian_status.dart';
import 'package:seeds/models/firebase/guardian_type.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/screens/shared/guardian_user_tile.dart';
import 'package:seeds/screens/shared/user_tile.dart';

class MyGuardiansTab extends StatefulWidget {
  final List<QueryDocumentSnapshot> guardians;

  MyGuardiansTab(this.guardians);

  @override
  State<StatefulWidget> createState() {
    return _MyGuardiansState();
  }
}

class _MyGuardiansState extends State<MyGuardiansTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MemberModel>>(
        future: HttpService().getMembersByIds(widget.guardians.map((e) => e.id).toList()),
        // FirebaseDatabaseService().getImGuardiansFor(SettingsNotifier.of(context).accountName),
        builder: (context, memberModels) {
          if (memberModels.hasData) {
            Iterable<MemberModel> users = memberModels.data;
            Iterable<DocumentSnapshot> myGuardians =
                widget.guardians.where((DocumentSnapshot e) => fromTypeName(e["type"]) == GuardianType.myGuardian);
            Iterable<String> myGuardiansIds = myGuardians.map((e) => e.id);
            Iterable<MemberModel> filteredList = users.where((item) => myGuardiansIds.contains(item.account));

            return ListView(
              children: filteredList
                  .map((e) => guardianUserTile(
                      user: e,
                      currentUserId: SettingsNotifier.of(context).accountName,
                      status: fromName(myGuardians.firstWhere((element) => element.id == e.account)["status"]),
                      onTap: () {}))
                  .toList(),
            );
          } else {
            return SizedBox.shrink();
          }
        });
  }
}
