import 'package:flutter/material.dart';
import 'package:seeds/models/firebase/guardian.dart';
import 'package:seeds/models/models.dart';

import 'guardian_user_tile.dart';

ListView buildGuardiansListView(
    List<MemberModel> memberModels, String currentUserId, List<Guardian> guardians, Function tileOnTap) {
  return ListView(
    children: memberModels
        .map((e) => guardianUserTile(
            user: e,
            currentUserId: currentUserId,
            status: guardians.firstWhere((element) => element.uid == e.account).status,
            tileOnTap: tileOnTap))
        .toList(),
  );
}
