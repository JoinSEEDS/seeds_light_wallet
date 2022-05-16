import 'package:flutter/material.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/components/guardian_row_widget.dart';

class MyGuardiansListWidget extends StatelessWidget {
  final String currentUserId;
  final List<GuardianModel> guardians;

  const MyGuardiansListWidget({super.key, required this.currentUserId, required this.guardians});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 10),
      children: guardians.map((GuardianModel guardian) => GuardianRowWidget(guardianModel: guardian)).toList(),
    );
  }
}
