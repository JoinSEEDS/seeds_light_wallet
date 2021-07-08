import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/v2/components/divider_jungle.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/components/snack_bar_info.dart';
import 'package:seeds/v2/components/text_form_field_custom.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/components/guardian_row_widget.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/interactor/recover_account_found_bloc.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_events.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_state.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_search/interactor/viewmodels/recover_account_page_command.dart';

import 'interactor/viewmodels/recover_account_found_page_command.dart';

class RecoverAccountFoundScreen extends StatelessWidget {
  const RecoverAccountFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: cast_nullable_to_non_nullable
    Input arguments = ModalRoute.of(context)!.settings.arguments as Input;
    return BlocProvider(
      create: (_) => RecoverAccountFoundBloc(
          arguments.guardians, arguments.userAccount, BlocProvider.of<AuthenticationBloc>(context))
        ..add(FetchInitialData()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Recover Account")),
        body: BlocConsumer<RecoverAccountFoundBloc, RecoverAccountFoundState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          var pageCommand = state.pageCommand;

          if (pageCommand is ShowActivateGuardiansLinkCopiedSuccess) {
            SnackBarInfo("Copied", ScaffoldMessenger.of(context)).show();
          }

        },
          builder: (context, state) {
            switch (state.pageState) {
              case PageState.initial:
                return const SizedBox.shrink();
              case PageState.loading:
                return const FullPageLoadingIndicator();
              case PageState.failure:
                return FullPageErrorIndicator(errorMessage: state.errorMessage);
              case PageState.success:
                switch (state.recoveryStatus) {
                  case RecoveryStatus.WAITING_FOR_GUARDIANS_TO_SIGN:
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                                child: TextFormFieldCustom(
                                  enabled: false,
                                  labelText: 'Link to Activate Key Guardians',
                                  suffixIcon: const SizedBox.shrink(),
                                  controller: TextEditingController(text: state.linkToActivateGuardians),
                                ),
                              ),
                              Positioned(
                                  right: 4,
                                  top: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8, top: 8),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.copy,
                                        color: AppColors.white,
                                      ),
                                      splashRadius: 30,
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(text: state.linkToActivateGuardians)).then(
                                          (value) {
                                            BlocProvider.of<RecoverAccountFoundBloc>(context).add(OnCopyIconTab());
                                          },
                                        );
                                      },
                                    ),
                                  )),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Text(state.confirmedGuardianSignatures.toString(),
                                    style: Theme.of(context).textTheme.button1),
                                Text("/" + state.userGuardians.length.toString(),
                                    style: Theme.of(context).textTheme.button1),
                                const SizedBox(
                                  width: 24,
                                ),
                                Flexible(
                                  child: Text(
                                    "Guardians have accepted your request to recover your account",
                                    style: Theme.of(context).textTheme.buttonLowEmphasis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                            child: DividerJungle(),
                          ),
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
                          )
                        ],
                      ),
                    );
                  default:
                    return Column(
                      children: [
                        Text(
                          "All three of your Key Guardians have accepted your request to recover your account. You account will be unlocked in 24hrs. ",
                          style: Theme.of(context).textTheme.subtitle2,
                          textAlign: TextAlign.center,
                        ),
                        SvgPicture.asset("assets/images/guardians/check_circle.svg"),
                        const Text("Time Left Before Recovery Enabled"),
                        Row(
                          children: [
                            Row(
                              children: [
                                Text('${state.currentRemainingTime?.hours ?? 0} ',
                                    style: Theme.of(context).textTheme.headline5),
                                Text(':', style: Theme.of(context).textTheme.subtitle3Opacity)
                              ],
                            ),
                            Row(
                              children: [
                                Text('${state.currentRemainingTime?.min ?? 0} ',
                                    style: Theme.of(context).textTheme.headline5),
                                Text(':', style: Theme.of(context).textTheme.subtitle3Opacity)
                              ],
                            ),
                            Row(
                              children: [
                                Text('${state.currentRemainingTime?.sec ?? 0} ',
                                    style: Theme.of(context).textTheme.headline5),
                              ],
                            )
                          ],
                        ),
                        state.recoveryStatus == RecoveryStatus.READY_TO_CLAIM_ACCOUNT
                            ? Text("Account recovered " + state.userAccount)
                            : const SizedBox.shrink(),
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: FlatButtonLong(
                            enabled: state.recoveryStatus == RecoveryStatus.READY_TO_CLAIM_ACCOUNT,
                            title: "Claim account",
                            onPressed: () {
                              BlocProvider.of<RecoverAccountFoundBloc>(context).add(OnClaimAccountTap());
                            },
                          ),
                        ),
                      ],
                    );
                }
            }
          },
        ),
      ),
    );
  }
}
