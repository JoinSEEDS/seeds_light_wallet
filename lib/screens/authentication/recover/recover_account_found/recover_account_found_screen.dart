import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/components/divider_jungle.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/flat_button_long_outlined.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/text_form_field_custom.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/global_error.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/components/guardian_row_widget.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_bloc.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_page_command.dart';
import 'package:seeds/utils/build_context_extension.dart';
import 'package:share/share.dart';

class RecoverAccountFoundScreen extends StatelessWidget {
  const RecoverAccountFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: cast_nullable_to_non_nullable
    final String userAccount = ModalRoute.of(context)!.settings.arguments as String;
    return BlocProvider(
      create: (_) => RecoverAccountFoundBloc(userAccount)..add(const FetchInitialData()),
      child: BlocConsumer<RecoverAccountFoundBloc, RecoverAccountFoundState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final pageCommand = state.pageCommand;
          BlocProvider.of<RecoverAccountFoundBloc>(context).add(const ClearRecoverPageCommand());

          if (pageCommand is ShowLinkCopied) {
            eventBus.fire(ShowSnackBar.success(context.loc.recoverAccountFoundShowLinkCopied));
          } else if (pageCommand is ShowErrorMessage) {
            eventBus.fire(ShowSnackBar(pageCommand.message));
          } else if (pageCommand is CancelRecoveryProcess) {
            Navigator.of(context).pop();
          } else if (pageCommand is OnRecoverAccountSuccess) {
            BlocProvider.of<AuthenticationBloc>(context).add(const OnRecoverAccount());
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
                appBar: AppBar(
                  title: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(context.loc.recoverAccountFoundAppBarTitle)),
                  automaticallyImplyLeading: false,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () => BlocProvider.of<RecoverAccountFoundBloc>(context).add(const OnRefreshTapped()),
                      ),
                    )
                  ],
                ),
                body: buildBody(state, context)),
          );
        },
      ),
    );
  }

  Widget buildBody(RecoverAccountFoundState state, BuildContext context) {
    switch (state.pageState) {
      case PageState.initial:
        return const SizedBox.shrink();
      case PageState.loading:
        return const FullPageLoadingIndicator();
      case PageState.failure:
        return FullPageErrorIndicator(
          errorMessage: state.error?.localizedDescription(context) ?? GlobalError.unknown.localizedDescription(context),
          buttonTitle: context.loc.recoverAccountFoundFullPageErrorIndicatorTitle,
          buttonOnPressed: () => BlocProvider.of<RecoverAccountFoundBloc>(context).add(const OnCancelProcessTapped()),
        );
      case PageState.success:
        switch (state.recoveryStatus) {
          case RecoveryStatus.waitingForGuardiansToSign:
            return SafeArea(
              minimum: const EdgeInsets.symmetric(vertical: 16),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                          child: TextFormFieldCustom(
                            enabled: false,
                            labelText: context.loc.recoverAccountFoundLinkTitle,
                            suffixIcon: const SizedBox.shrink(),
                            controller: TextEditingController(text: state.linkToActivateGuardians?.toString()),
                          ),
                        ),
                        Positioned(
                          right: 4,
                          top: 10,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8, top: 8),
                            child: IconButton(
                              icon: const Icon(Icons.share, color: AppColors.white),
                              splashRadius: 30,
                              onPressed: () async {
                                await Share.share(state.linkToActivateGuardians!.toString());
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Text(state.confirmedGuardianSignatures.toString(),
                              style: Theme.of(context).textTheme.button1),
                          Text("/${state.userGuardiansData.length}", style: Theme.of(context).textTheme.button1),
                          const SizedBox(width: 24),
                          Flexible(
                            child: Text(
                              context.loc.recoverAccountFoundGuardiansAcceptedTitle,
                              style: Theme.of(context).textTheme.buttonLowEmphasis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0), child: DividerJungle()),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children: state.userGuardiansData
                            .map((e) => GuardianRowWidget(
                                  guardianModel: e,
                                  showGuardianSigned: state.alreadySignedGuardians
                                      .where((String element) => element == e.account)
                                      .isNotEmpty,
                                ))
                            .toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding, vertical: 16),
                      child: FlatButtonLong(
                        title: context.loc.recoverAccountFoundReloadTitle,
                        onPressed: () => BlocProvider.of<RecoverAccountFoundBloc>(context).add(const OnRefreshTapped()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
                      child: FlatButtonLongOutlined(
                        title: context.loc.recoverAccountFoundFullPageErrorIndicatorTitle,
                        onPressed: () =>
                            BlocProvider.of<RecoverAccountFoundBloc>(context).add(const OnCancelProcessTapped()),
                      ),
                    ),
                  ],
                ),
              ),
            );
          default:
            return Scaffold(
              bottomSheet: Padding(
                padding: const EdgeInsets.all(horizontalEdgePadding),
                child: FlatButtonLong(
                  enabled: state.recoveryStatus == RecoveryStatus.readyToClaimAccount,
                  title: context.loc.recoverAccountFoundClaimButtonTitle,
                  onPressed: () => BlocProvider.of<RecoverAccountFoundBloc>(context).add(const OnClaimAccountTapped()),
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            context.loc.recoverAccountFoundAllGuardiansAcceptedTitle,
                            style: Theme.of(context).textTheme.subtitle2LowEmphasis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Image(image: AssetImage('assets/images/guardians/check_circle.png')),
                        const SizedBox(height: 100),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(state.currentRemainingTime?.hoursFormatted ?? '00',
                                    style: Theme.of(context).textTheme.headline4),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Text(':', style: Theme.of(context).textTheme.headline4),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(state.currentRemainingTime?.minFormatted ?? '00',
                                    style: Theme.of(context).textTheme.headline4),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Text(':', style: Theme.of(context).textTheme.headline4),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text('${state.currentRemainingTime?.secFormatted ?? '00'} ',
                                    style: Theme.of(context).textTheme.headline4),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: Text(context.loc.recoverAccountFoundHoursLeft,
                                  style: Theme.of(context).textTheme.subtitle2),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (state.recoveryStatus == RecoveryStatus.readyToClaimAccount)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text(context.loc.recoverAccountFoundRecoveredTitle), Text(state.userAccount)],
                          ),
                        const SizedBox(height: 150),
                      ],
                    ),
                  ),
                ),
              ),
            );
        }
    }
  }
}
