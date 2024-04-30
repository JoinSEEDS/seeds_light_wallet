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
import 'package:seeds/utils/build_context_extension.dart';

class VerificationScreen extends StatelessWidget {
  final bool _isUnpoppable;

  const VerificationScreen({super.key}) : _isUnpoppable = false;

  /// This contructor creates a unpoppable screen and use the main builder to unlock the app.
  const VerificationScreen.unpoppable({super.key}) : _isUnpoppable = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VerificationBloc()..add(const InitBiometricAuth()),
      child: WillPopScope(
        // User can only pop without auth if it is on security screen
        onWillPop: () async => !_isUnpoppable,
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
                  if (_isUnpoppable) {
                    // Onboarding or timeout authentication: just unlock
                    BlocProvider.of<AuthenticationBloc>(context).add(const UnlockWallet());
                  }
                  Navigator.of(context).pop(true);
                } else if (pageCommand is PasscodeValid) {
                  final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
                  if (state.isCreateMode) {
                    // Enable and save new passcode
                    authenticationBloc.add(EnablePasscode(newPasscode: state.newPasscode!));
                    if (_isUnpoppable) {
                      authenticationBloc.add(const UnlockWallet());
                    }
                    Navigator.of(context).pop(true);
                    const PasscodeCreatedDialog().show(context);
                  } else {
                    if (_isUnpoppable) {
                      // Onboarding or timeout authentication: just unlock
                      authenticationBloc.add(const UnlockWallet());
                    }
                    // pop from disable on security
                    Navigator.of(context).pop(true);
                  }
                }
              },
              builder: (context, state) {
                switch (state.pageState) {
                  case PageState.failure:
                  case PageState.success:
                    return PasscodeScreen(
                      title: Text(state.passcodeTitle.localizedDescription(context),
                          style: Theme.of(context).textTheme.titleSmall),
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
