import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seeds/models/firebase/guardian_type.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/firebase/firebase_database_map_keys.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/screens/app/guardians/im_guardian_for_tab.dart';
import 'package:seeds/screens/app/guardians/my_guardians_tab.dart';

class GuardianTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "My Guardians",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Im Guardian For",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              "Key Guardians",
              style: TextStyle(fontFamily: "worksans", color: Colors.black),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseDatabaseService().getAllUserGuardians(SettingsNotifier.of(context).accountName),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return TabBarView(
                    children: [
                      MyGuardiansTab(snapshot.data.docs
                          .where((DocumentSnapshot e) => fromTypeName(e[TYPE_KEY]) == GuardianType.myGuardian)
                          .toList()),
                      ImGuardianForTab(snapshot.data.docs
                          .where((DocumentSnapshot e) => fromTypeName(e[TYPE_KEY]) == GuardianType.imGuardian)
                          .toList()),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ));
  }
}
