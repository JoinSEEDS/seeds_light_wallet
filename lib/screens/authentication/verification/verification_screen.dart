import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/authentication/verification/components/passcode_created_dialog.dart';
import 'package:seeds/screens/authentication/verification/components/passcode_screen.dart';
import 'package:seeds/screens/authentication/verification/interactor/viewmodels/page_commands.dart';
import 'package:seeds/screens/authentication/verification/interactor/viewmodels/verification_bloc.dart';
import 'package:seeds/screens/profile_screens/security/interactor/viewmodels/security_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SecurityBloc? _securityBloc = ModalRoute.of(context)!.settings.arguments as SecurityBloc?;
    return BlocProvider(
      create: (_) => VerificationBloc()..add(const InitBiometricAuth()),
      child: WillPopScope(
        // User can only pop without auth if it is on security screen
        onWillPop: () async => _securityBloc != null,
        child: Scaffold(
          body: SafeArea(
            child: BlocConsumer<VerificationBloc, VerificationState>(
              listenWhen: (_, current) => current.pageCommand != null,
              listener: (context, state) {
                final pageCommand = state.pageCommand;
                BlocProvider.of<VerificationBloc>(context).add(const ClearVerificationPageCommand());
                if (pageCommand is PasscodeNotMatch) {
                  eventBus.fire(ShowSnackBar.success(context.loc.verificationScreenSnackBarError));
                } else if (pageCommand is BiometricAuthorized) {
                  final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
                  if (_securityBloc == null) {
                    // Onboarding or timeout authentication: just unlock
                    authenticationBloc.add(const UnlockWallet());
                  } else {
                    // Security flow: update screen and then fires navigator pop
                    _securityBloc.add(const OnValidVerification());
                    Navigator.of(context).pop();
                  }
                } else if (pageCommand is PasscodeValid) {
                  final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
                  _securityBloc?.add(const OnValidVerification());
                  if (state.isCreateMode) {
                    // Enable and save new passcode
                    authenticationBloc.add(EnablePasscode(newPasscode: state.newPasscode!));
                    Navigator.of(context).pop();
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const PasscodeCreatedDialog(),
                    );
                    if (_securityBloc == null) {
                      authenticationBloc.add(const UnlockWallet());
                    }
                  } else {
                    if (_securityBloc == null) {
                      // Onboarding or timeout authentication: just unlock
                      authenticationBloc.add(const UnlockWallet());
                    } else {
                      // pop from disable on security
                      Navigator.of(context).pop();
                    }
                  }
                }
              },
              builder: (context, state) {
                switch (state.pageState) {
                  case PageState.failure:
                  case PageState.success:
                    return PasscodeScreen(
                      title: Text(state.passcodeTitle.localizedDescription(context),
                          style: Theme.of(context).textTheme.subtitle2),
                      onPasscodeCompleted: (passcode) {
                        if (state.isCreateMode && state.newPasscode == null) {
                          BlocProvider.of<VerificationBloc>(context).add(OnPasscodeCreated(passcode));
                        } else {
                          BlocProvider.of<VerificationBloc>(context).add(OnVerifyPasscode(passcode));
                        }
                      },
                      bottomWidget: state.showTryAgainBiometric
                          ? Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: InkWell(
                                onTap: () => BlocProvider.of<VerificationBloc>(context).add(const InitBiometricAuth()),
                                borderRadius: BorderRadius.circular(16.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      border: Border.all(color: AppColors.white)),
                                  child: Text(context.loc.verificationScreenButtonTitle,
                                      style: Theme.of(context).textTheme.subtitle2),
                                ),
                              ),
                            )
                          : null,
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
