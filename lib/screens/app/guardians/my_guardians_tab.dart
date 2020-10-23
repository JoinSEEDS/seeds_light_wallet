import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seeds/models/firebase/guardian_status.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/firebase/firebase_database_map_keys.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/screens/shared/guardian_user_tile.dart';

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
        builder: (context, memberModels) {
          if (memberModels.hasData) {
            return ListView(
              children: memberModels.data
                  .map((e) => guardianUserTile(
                      user: e,
                      currentUserId: SettingsNotifier.of(context).accountName,
                      status: fromName(
                          widget.guardians.firstWhere((element) => element.id == e.account)[GUARDIANS_STATUS_KEY]),
                      onTap: () {}))
                  .toList(),
            );
          } else {
            return SizedBox.shrink();
          }
        });
  }
}
