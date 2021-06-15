import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/components/profile_avatar.dart';
import 'package:seeds/v2/components/snack_bar_info.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/components/im_guardian_for_tab.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/components/my_guardians_tab.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/guardians_bloc.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_events.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_state.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/page_commands.dart';
import 'components/onboarding_dialog_double_action.dart';
import 'components/onboarding_dialog_single_action.dart';

/// GuardiansScreen SCREEN
class GuardiansScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => GuardiansBloc(),
        child: BlocListener<GuardiansBloc, GuardiansState>(
            listenWhen: (_, current) => current.pageCommand != null,
            listener: (context, state) {
              var pageCommand = state.pageCommand;
              BlocProvider.of<GuardiansBloc>(context).add(ClearPageCommand());

              if (pageCommand is NavigateToRouteWithArguments) {
                NavigationService.of(context).navigateTo(pageCommand.route, pageCommand.arguments);
              } else if (pageCommand is ShowRecoveryStarted) {
                _showRecoveryStartedBottomSheet(context, pageCommand.guardian);
              } else if (pageCommand is ShowRemoveGuardianView) {
                _showRemoveGuardianDialog(context, pageCommand.guardian);
              } else if (pageCommand is ShowErrorMessage) {
                SnackBarInfo(pageCommand.message, ScaffoldMessenger.of(context)).show();
              } else if(pageCommand is ShowMessage) {
                SnackBarInfo(pageCommand.message, ScaffoldMessenger.of(context)).show();
              } else if (pageCommand is ShowOnboardingGuardianSingleAction){
                _showOnboardingGuardianDialogSingleAction( pageCommand ,context);
              }else if (pageCommand is ShowOnboardingGuardianDoubleAction){
                _showOnboardingGuardianDialogDoubleAction(pageCommand, context);
              }

            },
            child: BlocBuilder<GuardiansBloc, GuardiansState>(builder: (context, state) {
              return DefaultTabController(
                  length: 2,
                  child: Scaffold(
                      floatingActionButton: state.pageState == PageState.loading
                          ? const SizedBox.shrink()
                          : FloatingActionButton.extended(
                              label: const Text("Add Guardians"),
                              onPressed: () {
                                BlocProvider.of<GuardiansBloc>(context).add(OnAddGuardiansTapped());
                              },
                            ),
                      appBar: AppBar(
                        bottom: const TabBar(
                          tabs: [
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text("My Guardians"),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text("Im Guardian For"),
                            )
                          ],
                        ),
                        automaticallyImplyLeading: true,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        title: const Text("Key Guardians"),
                        centerTitle: true,
                      ),
                      body: state.pageState == PageState.loading
                          ? const FullPageLoadingIndicator()
                          : const TabBarView(
                              children: [
                                MyGuardiansTab(),
                                ImGuardianForTab(),
                              ],
                            )));
            })));
  }
}

void _showRecoveryStartedBottomSheet(BuildContext context, GuardianModel guardian) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Container(
                  child: const SizedBox(height: 2, width: 40),
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Center(
                    child: Text(
                  "A motion to Recover your Key has been initiated by ${guardian.nickname}",
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                )),
              ),
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: () {
                  _showStopRecoveryConfirmationDialog(guardian, context);
                },
                label: const Text(
                  "Stop this Recovery",
                  style: TextStyle(color: Colors.blue),
                ),
                icon: const Icon(Icons.cancel_rounded, color: AppColors.darkGreen3),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showStopRecoveryConfirmationDialog(GuardianModel guardian, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content:
            const Text("Are you sure you want to stop key recovery process", style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            child: const Text('No: Dismiss'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text("Yes: Stop Key Recovery"),
            onPressed: () {
              BlocProvider.of<GuardiansBloc>(context).add(OnStopRecoveryForUser());
              Navigator.pop(context);
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}

void _showRemoveGuardianDialog(BuildContext buildContext, GuardianModel guardian) {
  showDialog(
    context: buildContext,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Are you sure you want to remove ",
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: ProfileAvatar(
                size: 60,
                image: guardian.image,
                account: guardian.uid,
                nickname: guardian.nickname,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.blue,
                ),
              ),
              title: Text(
                "${guardian.nickname}",
                style: const TextStyle(color: Colors.black),
              ),
              subtitle: Text("${guardian.uid}"),
            ),
            const SizedBox(height: 16),
            const Text("As your Guardian?"),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Dismiss'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Remove Guardian'),
            onPressed: () async {
              BlocProvider.of<GuardiansBloc>(buildContext).add(OnRemoveGuardianTapped(guardian));
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}

void _showOnboardingGuardianDialogSingleAction(ShowOnboardingGuardianSingleAction pageCommand, BuildContext buildContext) {
  showDialog(
      context: buildContext,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: OnboardingDialogSingleAction(
                buttonTitle: pageCommand.buttonTitle,
                indexDialong: pageCommand.index,
                image: pageCommand.image,
                description: pageCommand.description,
                onNext: () {
                  BlocProvider.of<GuardiansBloc>(buildContext).add(OnNextGuardianOnboardingTapped());
                  Navigator.pop(context);
                }),
          ),
        );
      });
}

void _showOnboardingGuardianDialogDoubleAction(ShowOnboardingGuardianDoubleAction pageCommand, BuildContext buildContext) {
  showDialog(
      context: buildContext,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: OnboardingDialogDoubleAction(
              rightButtonTitle: pageCommand.rightButtonTitle,
              leftButtonTitle: pageCommand.leftButtonTitle,
              indexDialong: pageCommand.index,
              image: pageCommand.image,
              description: pageCommand.description,
              onNext: () {
                BlocProvider.of<GuardiansBloc>(buildContext).add(OnNextGuardianOnboardingTapped());
                Navigator.pop(context);
              },
              onPrevious: () {
                BlocProvider.of<GuardiansBloc>(buildContext).add(OnPreviousGuardianOnboardingTapped());
                Navigator.pop(context);
              },
            ),
          ),
        );
      });
}
