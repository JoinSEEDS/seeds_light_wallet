import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/search_user/search_user_widget.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/select_guardian/components/selected_guardians_widget.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/select_guardian/interactor/select_guardians_bloc.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/select_guardian/interactor/viewmodels/page_commands.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/select_guardian/interactor/viewmodels/select_guardians_events.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/select_guardian/interactor/viewmodels/select_guardians_state.dart';

/// SelectGuardiansScreen SCREEN
class SelectGuardiansScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var myGuardians = ModalRoute.of(context)?.settings.arguments as List<GuardianModel>?;

    return BlocProvider(
        create: (_) => SelectGuardiansBloc(myGuardians ?? []),
        child: BlocListener<SelectGuardiansBloc, SelectGuardiansState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            if (state.pageCommand is ShowMaxUserCountSelected) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(seconds: 1),
                  // ignore: cast_nullable_to_non_nullable
                  content: Text((state.pageCommand as ShowMaxUserCountSelected).message)));
            }

            BlocProvider.of<SelectGuardiansBloc>(context).add(ClearPageCommand());
          },
          child: BlocBuilder<SelectGuardiansBloc, SelectGuardiansState>(builder: (context, state) {
            return Scaffold(
                appBar: AppBar(title: Text(state.pageTitle)),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4, left: 16, right: 16),
                            child: state.selectedGuardians.isEmpty
                                ? const SizedBox.shrink()
                                : const SelectedGuardiansWidget(),
                          ),
                          Expanded(
                              child: SearchUserWidget(
                                  noShowUsers: state.noShowGuardians,
                                  resultCallBack: (MemberModel selectedUser) {
                                    BlocProvider.of<SelectGuardiansBloc>(context).add(OnUserSelected(selectedUser));
                                  })),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: FlatButtonLong(
                              title: 'Next',
                              onPressed: state.selectedGuardians.isNotEmpty
                                  ? () => {
                                        NavigationService.of(context)
                                            .navigateTo(Routes.inviteGuardians, state.selectedGuardians),
                                      }
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ));
          }),
        ));
  }
}
