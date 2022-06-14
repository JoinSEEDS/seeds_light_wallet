import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/i18n/profile_screens/guardians/guardians.i18n.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/components/im_guardian_for_tab.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/components/my_guardians_tab.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/components/onboarding_dialog_double_action.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/components/onboarding_dialog_single_action.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/components/remove_guardian_confirmation_dialog.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_bloc.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/page_commands.dart';

class GuardiansScreen extends StatelessWidget {
  const GuardiansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GuardiansBloc(),
      child: BlocListener<GuardiansBloc, GuardiansState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final pageCommand = state.pageCommand;
          BlocProvider.of<GuardiansBloc>(context).add(const ClearPageCommand());

          if (pageCommand is NavigateToRouteWithArguments) {
            NavigationService.of(context).navigateTo(pageCommand.route, pageCommand.arguments);
          } else if (pageCommand is ShowRecoveryStarted) {
            _showRecoveryStartedBottomSheet(context, pageCommand.guardian);
          } else if (pageCommand is ShowRemoveGuardianView) {
            _showRemoveGuardianDialog(context, pageCommand.guardian);
          } else if (pageCommand is ShowErrorMessage) {
            eventBus.fire(ShowSnackBar(pageCommand.message));
          } else if (pageCommand is ShowMessage) {
            eventBus.fire(ShowSnackBar(pageCommand.message));
          } else if (pageCommand is ShowOnboardingGuardianSingleAction) {
            _showOnboardingGuardianDialogSingleAction(pageCommand, context);
          } else if (pageCommand is ShowOnboardingGuardianDoubleAction) {
            _showOnboardingGuardianDialogDoubleAction(pageCommand, context);
          } else if (pageCommand is ShowActivateGuardian) {
            _showActivateGuardianDialog(pageCommand, context);
          }
        },
        child: BlocBuilder<GuardiansBloc, GuardiansState>(
          builder: (context, state) {
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                bottomNavigationBar: state.pageState == PageState.loading
                    ? const SizedBox.shrink()
                    : SafeArea(
                        minimum: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                        child: FlatButtonLong(
                          title: "+ Add Guardians".i18n,
                          isLoading: state.isAddGuardianButtonLoading,
                          enabled: !state.isAddGuardianButtonLoading,
                          onPressed: () {
                            BlocProvider.of<GuardiansBloc>(context).add(OnAddGuardiansTapped());
                          },
                        ),
                      ),
                appBar: AppBar(
                  bottom: TabBar(
                    tabs: [
                      Padding(padding: const EdgeInsets.all(16.0), child: Text("My Guardians".i18n)),
                      Padding(padding: const EdgeInsets.all(16.0), child: Text("I'm Guardian For".i18n))
                    ],
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text("Key Guardians".i18n),
                ),
                body: state.pageState == PageState.loading
                    ? const FullPageLoadingIndicator()
                    : const SafeArea(child: TabBarView(children: [MyGuardiansTab(), ImGuardianForTab()])),
              ),
            );
          },
        ),
      ),
    );
  }
}

void _showRecoveryStartedBottomSheet(BuildContext context, GuardianModel guardian) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Container(
                color: Colors.black,
                child: const SizedBox(height: 2, width: 40),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Center(
                child: RichText(
                  text: TextSpan(
                      text: 'A motion to Recover your Key has been initiated by '.i18n,
                      style: Theme.of(context).textTheme.button,
                      children: <TextSpan>[
                        TextSpan(text: guardian.nickname, style: Theme.of(context).textTheme.button)
                      ]),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {
                _showStopRecoveryConfirmationDialog(guardian, context);
              },
              label: Text(
                "Stop this Recovery".i18n,
                style: const TextStyle(color: Colors.blue),
              ),
              icon: const Icon(Icons.cancel_rounded, color: AppColors.darkGreen3),
            ),
          ],
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
        content: Text("Are you sure you want to stop key recovery process".i18n,
            style: const TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No: Dismiss'.i18n),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<GuardiansBloc>(context).add(OnStopRecoveryForUser());
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Yes: Stop Key Recovery".i18n),
          )
        ],
      );
    },
  );
}

void _showRemoveGuardianDialog(BuildContext buildContext, GuardianModel guardian) {
  showDialog(
    context: buildContext,
    builder: (context) {
      return RemoveGuardianConfirmationDialog(
        guardian: guardian,
        onConfirm: () {
          BlocProvider.of<GuardiansBloc>(buildContext).add(OnRemoveGuardianTapped(guardian));
          Navigator.pop(context);
        },
        onDismiss: () => Navigator.pop(context),
      );
    },
  );
}

void _showOnboardingGuardianDialogSingleAction(
    ShowOnboardingGuardianSingleAction pageCommand, BuildContext buildContext) {
  showDialog(
      context: buildContext,
      builder: (BuildContext context) {
        return OnboardingDialogSingleAction(
            buttonTitle: pageCommand.buttonTitle,
            indexDialong: pageCommand.index,
            image: pageCommand.image,
            description: pageCommand.description,
            onNext: () {
              BlocProvider.of<GuardiansBloc>(buildContext).add(const OnNextGuardianOnboardingTapped());
              Navigator.pop(context);
            });
      });
}

void _showOnboardingGuardianDialogDoubleAction(
    ShowOnboardingGuardianDoubleAction pageCommand, BuildContext buildContext) {
  showDialog(
    context: buildContext,
    builder: (context) {
      return OnboardingDialogDoubleAction(
        rightButtonTitle: pageCommand.rightButtonTitle,
        leftButtonTitle: pageCommand.leftButtonTitle,
        indexDialong: pageCommand.index,
        image: pageCommand.image,
        description: pageCommand.description,
        onRightButtonTab: () {
          BlocProvider.of<GuardiansBloc>(buildContext).add(const OnNextGuardianOnboardingTapped());
          Navigator.pop(context);
        },
        onLeftButtonTab: () {
          BlocProvider.of<GuardiansBloc>(buildContext).add(const OnPreviousGuardianOnboardingTapped());
          Navigator.pop(context);
        },
      );
    },
  );
}

void _showActivateGuardianDialog(ShowActivateGuardian pageCommand, BuildContext buildContext) {
  showDialog(
    context: buildContext,
    builder: (context) {
      return OnboardingDialogDoubleAction(
        rightButtonTitle: pageCommand.rightButtonTitle,
        leftButtonTitle: pageCommand.leftButtonTitle,
        indexDialong: pageCommand.index,
        image: pageCommand.image,
        description: pageCommand.description,
        onRightButtonTab: () {
          BlocProvider.of<GuardiansBloc>(buildContext).add(InitGuardians(pageCommand.myGuardians));
          Navigator.pop(context);
        },
        onLeftButtonTab: () {
          Navigator.pop(context);
        },
      );
    },
  );
}
