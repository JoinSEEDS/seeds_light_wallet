import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/search_user/search_user_widget.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/select_guardian/interactor/select_guardians_bloc.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/select_guardian/interactor/viewmodels/select_guardians_events.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/select_guardian/interactor/viewmodels/select_guardians_state.dart';

const _MAX_GUARDIANS_ALLOWED = 5;

/// SelectGuardiansScreen SCREEN
class SelectGuardiansScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var myGuardians = ModalRoute.of(context)?.settings.arguments as List<GuardianModel>?;
    int selectedGuardiansCount = myGuardians?.length ?? 0;

    return BlocProvider(
        create: (context) => SelectGuardiansBloc(),
        child: Scaffold(
            appBar: AppBar(
              title: Text("Select up to ${_MAX_GUARDIANS_ALLOWED - selectedGuardiansCount} Guardians to invite",
                  style: Theme.of(context).textTheme.headline7),
            ),
            body: BlocBuilder<SelectGuardiansBloc, SelectGuardiansState>(builder: (context, state) {
              return Column(
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
                              ? Container()
                              : Wrap(
                                  children: state.selectedGuardians
                                      .toList()
                                      .reversed
                                      .map((user) => Padding(
                                            padding: const EdgeInsets.only(right: 4),
                                            child: ActionChip(
                                              label: Text((user.nickname == null || user.nickname?.isEmpty == true)
                                                  ? user.account
                                                  : user.nickname!),
                                              avatar: const Icon(Icons.highlight_off),
                                              onPressed: () {
                                                BlocProvider.of<SelectGuardiansBloc>(context).add(OnUserRemoved(user));
                                              },
                                            ),
                                          ))
                                      .toList(),
                                ),
                        ),
                        Expanded(child: SearchUserWidget(resultCallBack: (MemberModel selectedUser) {
                          BlocProvider.of<SelectGuardiansBloc>(context).add(OnUserSelected(selectedUser));
                        })),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: FlatButtonLong(
                            title: 'Next',
                            onPressed: () => {
                              if (state.selectedGuardians.isNotEmpty)
                                {
                                  NavigationService.of(context)
                                      .navigateTo(Routes.inviteGuardians, state.selectedGuardians),
                                }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            })));
  }
}
