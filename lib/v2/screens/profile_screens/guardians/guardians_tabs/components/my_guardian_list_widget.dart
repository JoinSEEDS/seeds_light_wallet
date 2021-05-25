import 'package:flutter/material.dart';
import 'package:seeds/v2/components/search_result_row.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/components/my_guardian_separator_widget.dart';

class MyGuardiansListWidget extends StatelessWidget {
  final String currentUserId;
  final List<GuardianModel> guardians;

  const MyGuardiansListWidget({Key? key, required this.currentUserId, required this.guardians}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: guardians.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const SizedBox.shrink();
          }

          var guardian = guardians[index - 1];

          return SearchResultRow(
            account: guardian.uid,
            imageUrl: guardian.image,
            name: guardian.nickname,
            resultCallBack: (){},
          );
        },
        separatorBuilder: (context, index) {
          return GuardianListSeparatorWidget(guardians: guardians, index: index);
        });
  }
}
