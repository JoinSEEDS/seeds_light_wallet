import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/i18n/authentication/verification/verification.i18n.dart';
import 'package:seeds/screens/authentication/verification/components/passcode_created_dialog.dart';
import 'package:seeds/screens/authentication/verification/components/passcode_screen.dart';
import 'package:seeds/screens/authentication/verification/interactor/viewmodels/page_commands.dart';
import 'package:seeds/screens/authentication/verification/interactor/viewmodels/verification_bloc.dart';
import 'package:seeds/screens/profile_screens/security/interactor/viewmodels/security_bloc.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SecurityBloc? _securityBloc = ModalRoute.of(context)!.settings.arguments as SecurityBloc?;
    return BlocProvider(
      create: (context) => VerificationBloc(
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context), securityBloc: _securityBloc)
        ..add(const InitVerification()),
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
                if (pageCommand is PasscodeCreatedFromSecurity) {
                  Navigator.of(context).pop();
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const PasscodeCreatedDialog(),
                  );
                } else if (pageCommand is PasscodeNotMatch) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.canopy,
                      content: Text(
                        'Pincode does not match'.i18n,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  );
                } else if (pageCommand is PopVerificationScreen) {
                  Navigator.of(context).pop();
                }
              },
              builder: (context, state) {
                switch (state.pageState) {
                  case PageState.loading:
                    return const FullPageLoadingIndicator();
                  case PageState.failure:
                    return const FullPageErrorIndicator();
                  case PageState.success:
                    return PasscodeScreen(
                      title: Text(state.passcodeTitle.i18n, style: Theme.of(context).textTheme.subtitle2),
                      onPasscodeCompleted: (passcode) {
                        if (state.isCreateView!) {
                          BlocProvider.of<VerificationBloc>(context).add(OnCreatePasscode(passcode: passcode));
                        } else {
                          BlocProvider.of<VerificationBloc>(context).add(OnVerifyPasscode(passcode: passcode));
                        }
                      },
                      bottomWidget: state.showTryAgainBiometric
                          ? Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: InkWell(
                                onTap: () => BlocProvider.of<VerificationBloc>(context).add(const TryAgainBiometric()),
                                borderRadius: BorderRadius.circular(16.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      border: Border.all(color: AppColors.white)),
                                  child: Text('Use biometric to unlock'.i18n,
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
