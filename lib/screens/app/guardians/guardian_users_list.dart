import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seeds/models/firebase/guardian_status.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/firebase/firebase_database_map_keys.dart';

import 'guardian_user_tile.dart';

ListView buildGuardiansListView(
    AsyncSnapshot<List<MemberModel>> memberModels, String currentUserId, List<QueryDocumentSnapshot> guardians, GestureTapCallback tileOnTap) {
  return ListView(
    children: memberModels.data
        .map((e) => guardianUserTile(
            user: e,
            currentUserId: currentUserId,
            status: fromName(guardians.firstWhere((element) => element.id == e.account)[GUARDIANS_STATUS_KEY]),
            tileOnTap: tileOnTap))
        .toList(),
  );
}
