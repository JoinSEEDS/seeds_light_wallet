import 'package:flutter/material.dart';
import 'package:seeds/models/firebase/guardian.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/screens/app/guardians/guardian_users_list.dart';

class ImGuardianForTab extends StatefulWidget {
  final List<Guardian> guardians;

  ImGuardianForTab(this.guardians);

  @override
  State<StatefulWidget> createState() {
    return _ImGuardianForState();
  }
}

class _ImGuardianForState extends State<ImGuardianForTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MemberModel>>(
        future: HttpService().getMembersByIds(widget.guardians.map((e) => e.uid).toList()),
        builder: (context, memberModels) {
          if (memberModels.hasData) {
            return buildGuardiansListView(
                memberModels, SettingsNotifier.of(context).accountName, widget.guardians, () {});
          } else {
            return SizedBox.shrink();
          }
        });
  }
}
