import 'package:flutter/material.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/components/guardian_row_widget.dart';

class MyGuardiansListWidget extends StatelessWidget {
  final String currentUserId;
  final List<GuardianModel> guardians;

  const MyGuardiansListWidget({Key? key, required this.currentUserId, required this.guardians}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: guardians.map((GuardianModel guardian) => GuardianRowWidget(guardianModel: guardian)).toList(),
    );
  }
}
