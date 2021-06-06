import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_type.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/components/my_guardian_list_widget.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/components/no_guardian_widget.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/guardians_bloc.dart';

class ImGuardianForTab extends StatelessWidget {
  const ImGuardianForTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<GuardianModel>>(
        stream: BlocProvider.of<GuardiansBloc>(context).guardians,
        builder: (context, AsyncSnapshot<List<GuardianModel>> snapshot) {
          if (snapshot.hasData) {
            var myGuardians = snapshot.data!.where((element) => element.type == GuardianType.imGuardian);

            if (myGuardians.isEmpty) {
              return const NoGuardiansWidget(
                message: "No users have added you to become their guardian yet. "
                    "Once they do, you will see their request here.",
              );
            } else {
              List<Widget> items = [];

              items.add(Expanded(
                  child: MyGuardiansListWidget(
                currentUserId: settingsStorage.accountName,
                guardians: myGuardians.toList(),
              )));

              return Column(children: items);
            }
          } else {
            return const FullPageLoadingIndicator();
          }
        });
  }
}
