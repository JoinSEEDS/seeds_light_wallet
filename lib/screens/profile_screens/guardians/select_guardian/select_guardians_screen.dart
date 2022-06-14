import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/search_user/search_user.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/i18n/profile_screens/guardians/guardians.i18n.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/profile_screens/guardians/select_guardian/components/selected_guardians_widget.dart';
import 'package:seeds/screens/profile_screens/guardians/select_guardian/interactor/viewmodels/page_commands.dart';
import 'package:seeds/screens/profile_screens/guardians/select_guardian/interactor/viewmodels/select_guardians_bloc.dart';

class SelectGuardiansScreen extends StatelessWidget {
  const SelectGuardiansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final myGuardians = ModalRoute.of(context)?.settings.arguments as List<GuardianModel>?;

    return BlocProvider(
      create: (_) => SelectGuardiansBloc(myGuardians ?? []),
      child: BlocListener<SelectGuardiansBloc, SelectGuardiansState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          if (state.pageCommand is ShowMaxUserCountSelected) {
            eventBus.fire(ShowSnackBar((state.pageCommand! as ShowMaxUserCountSelected).message));
          }

          BlocProvider.of<SelectGuardiansBloc>(context).add(const ClearPageCommand());
        },
        child: BlocBuilder<SelectGuardiansBloc, SelectGuardiansState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(title: Text(state.pageTitle)),
              body: SafeArea(
                minimum: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 4, left: horizontalEdgePadding, right: horizontalEdgePadding),
                            child: state.selectedGuardians.isEmpty
                                ? const SizedBox.shrink()
                                : const SelectedGuardiansWidget(),
                          ),
                          Expanded(
                            child: SearchUser(
                              noShowUsers: state.noShowGuardians,
                              onUserSelected: (selectedUser) {
                                BlocProvider.of<SelectGuardiansBloc>(context).add(OnUserSelected(selectedUser));
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
                            child: FlatButtonLong(
                              title: 'Next'.i18n,
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
