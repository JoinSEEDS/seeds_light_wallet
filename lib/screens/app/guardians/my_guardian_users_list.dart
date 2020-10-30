import 'package:flutter/material.dart';
import 'package:seeds/models/firebase/guardian.dart';
import 'package:seeds/models/firebase/guardian_status.dart';
import 'package:seeds/models/models.dart';

import 'guardian_user_tile.dart';

ListView buildMyGuardiansListView(
    List<MemberModel> memberModels, String currentUserId, List<Guardian> guardians, Function tileOnTap) {
  guardians.sort((Guardian a, Guardian b) => a.status.index.compareTo(b.status.index));

  return ListView.separated(
      itemCount: guardians.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return SizedBox.shrink();
        }

        var guardian = guardians[index - 1];

        return guardianUserTile(
            user: memberModels.firstWhere((element) => element.account == guardian.uid),
            currentUserId: currentUserId,
            guardian: guardian,
            tileOnTap: tileOnTap);
      },
      separatorBuilder: (context, index) {
        return buildSeparator(guardians, index);
      });
}

Widget buildSeparator(List<Guardian> guardians, int index) {
  var requested = Container(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
      child: Center(child: Text("Requested")),
    ),
  );

  if (index == 0) {
    var guardian = guardians[index];
    if (guardian.status == GuardianStatus.alreadyGuardian) {
      return Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: Center(child: Text("Your Guardians")),
        ),
      );
    } else {
      return requested;
    }
  } else if (index > guardians.length - 2) {
    return SizedBox.shrink();
  } else {
    var guardian = guardians[index - 1];
    var next = guardians[index];

    if (guardian.status != next.status) {
      return requested;
    } else {
      return SizedBox.shrink();
    }
  }
}
