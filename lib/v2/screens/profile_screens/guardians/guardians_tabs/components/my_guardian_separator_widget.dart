import 'package:flutter/material.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_status.dart';

class GuardianListSeparatorWidget extends StatelessWidget {
  final int index;
  final List<GuardianModel> guardians;

  const GuardianListSeparatorWidget({Key? key, required this.index, required this.guardians}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var requested = Container(
      child: const Padding(
        padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
        child: Center(child: Text("Requested")),
      ),
    );

    if (index == 0) {
      var guardian = guardians[index];
      if (guardian.status == GuardianStatus.alreadyGuardian) {
        return Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            child: Center(
              child: Text(
                "My Guardians",
                style: Theme.of(context).textTheme.subtitle2HighEmphasis,
              ),
            ),
          ),
        );
      } else {
        return requested;
      }
    } else if (index > guardians.length - 1) {
      return const SizedBox.shrink();
    } else {
      var guardian = guardians[index - 1];
      var next = guardians[index];

      if (guardian.status != next.status) {
        return requested;
      } else {
        return const SizedBox.shrink();
      }
    }
  }
}
