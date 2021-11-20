import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/blocs/authentication/viewmodels/bloc.dart';
import 'package:seeds/blocs/deeplink/viewmodels/deeplink_bloc.dart';
import 'package:seeds/screens/authentication/sign_up2/claim_invite_screen.dart';
import 'package:seeds/screens/authentication/sign_up2/create_account_name_screen.dart';
import 'package:seeds/screens/authentication/sign_up2/create_display_name_screen.dart';
import 'package:seeds/screens/authentication/sign_up2/viewmodels/page_commands.dart';
import 'package:seeds/screens/authentication/sign_up2/viewmodels/signup_bloc.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupBloc()
        ..add(OnInviteCodeFromDeepLink(BlocProvider.of<DeeplinkBloc>(context).state.inviteLinkData?.mnemonic)),
      child: BlocConsumer<SignupBloc, SignupState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final pageCommand = state.pageCommand;
          if (pageCommand is OnAccountCreated) {
            BlocProvider.of<AuthenticationBloc>(context)
                .add(OnCreateAccount(account: state.accountName!, authData: pageCommand.authData));
          }
        },
        buildWhen: (previous, current) => previous.signupScreens != current.signupScreens,
        builder: (_, state) {
          final SignupScreens signupScreens = state.signupScreens;
          switch (signupScreens) {
            case SignupScreens.claimInvite:
              return const ClaimInviteScreen();
            case SignupScreens.displayName:
              return const CreateDisplayNameScreen();
            case SignupScreens.accountName:
              return const CreateAccountNameScreen();
          }
        },
      ),
    );
  }
}
