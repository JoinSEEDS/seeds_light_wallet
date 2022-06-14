import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_type.dart';
import 'package:seeds/i18n/profile_screens/guardians/guardians.i18n.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/components/my_guardian_list_widget.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/components/no_guardian_widget.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_bloc.dart';

class ImGuardianForTab extends StatelessWidget {
  const ImGuardianForTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<GuardianModel>>(
      stream: BlocProvider.of<GuardiansBloc>(context).guardians,
      builder: (context, AsyncSnapshot<List<GuardianModel>> snapshot) {
        if (snapshot.hasData) {
          final myGuardians = snapshot.data!.where((element) => element.type == GuardianType.imGuardian);

          if (myGuardians.isEmpty) {
            return NoGuardiansWidget(
                message:
                    "No users have added you to become their guardian yet. Once they do, you will see their request here."
                        .i18n);
          } else {
            return MyGuardiansListWidget(
              currentUserId: settingsStorage.accountName,
              guardians: myGuardians.toList(),
            );
          }
        } else {
          return const FullPageLoadingIndicator();
        }
      },
    );
  }
}
