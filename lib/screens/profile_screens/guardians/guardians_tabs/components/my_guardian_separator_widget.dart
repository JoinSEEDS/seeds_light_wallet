import 'package:flutter/material.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_status.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/i18n/profile_screens/guardians/guardians.i18n.dart';

class GuardianListSeparatorWidget extends StatelessWidget {
  final int index;
  final List<GuardianModel> guardians;

  const GuardianListSeparatorWidget({super.key, required this.index, required this.guardians});

  @override
  Widget build(BuildContext context) {
    final requested = Padding(
      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
      child: Center(child: Text("Requested".i18n)),
    );

    if (index == 0) {
      final guardian = guardians[index];
      if (guardian.status == GuardianStatus.alreadyGuardian) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: Center(
            child: Text(
              "My Guardians".i18n,
              style: Theme.of(context).textTheme.subtitle2HighEmphasis,
            ),
          ),
        );
      } else {
        return requested;
      }
    } else if (index > guardians.length - 1) {
      return const SizedBox.shrink();
    } else {
      final guardian = guardians[index - 1];
      final next = guardians[index];

      if (guardian.status != next.status) {
        return requested;
      } else {
        return const SizedBox.shrink();
      }
    }
  }
}
