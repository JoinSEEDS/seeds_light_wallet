import 'package:flutter/material.dart';
import 'package:seeds/models/firebase/guardian.dart';
import 'package:seeds/models/models.dart';

import 'guardian_user_tile.dart';

Widget buildGuardiansListView(List<MemberModel> memberModels, String currentUserId,
    List<Guardian> guardians, GestureTapCallback tileOnTap) {
  return memberModels.isNotEmpty ? ListView(
    children: memberModels
        .map((e) => guardianUserTile(
            user: e,
            currentUserId: currentUserId,
            status: guardians.firstWhere((element) => element.uid == e.account, orElse: () => null)?.status,
            tileOnTap: tileOnTap))
        .toList(),
  ) : SizedBox.shrink();
}
