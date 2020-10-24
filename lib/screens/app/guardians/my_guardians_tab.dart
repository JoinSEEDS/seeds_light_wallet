import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seeds/models/firebase/guardian.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/screens/app/guardians/guardian_users_list.dart';

class MyGuardiansTab extends StatefulWidget {
  final List<Guardian> guardians;

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
        future: HttpService().getMembersByIds(widget.guardians.map((e) => e.uid).toList()),
        builder: (context, memberModels) {
          if (memberModels.hasData) {
            return buildGuardiansListView(memberModels, SettingsNotifier.of(context).accountName, widget.guardians, () {
              // TODO: Not sure what we do here
            });
          } else {
            return SizedBox.shrink();
          }
        });
  }
}
