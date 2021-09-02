import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/deeplink/viewmodels/deeplink_bloc.dart';
import 'package:seeds/datasource/remote/api/signup_repository.dart';
import 'package:seeds/datasource/remote/firebase/firebase_user_repository.dart';
import 'package:seeds/screens/authentication/sign_up/create_username/usecases/create_account_usecase.dart';
import 'package:seeds/screens/authentication/sign_up/claim_invite/claim_invite_screen.dart';
import 'package:seeds/screens/authentication/sign_up/claim_invite/usecases/claim_invite_usecase.dart';
import 'package:seeds/screens/authentication/sign_up/create_username/create_username.dart';
import 'package:seeds/screens/authentication/sign_up/create_username/usecases/create_username_usecase.dart';
import 'package:seeds/screens/authentication/sign_up/display_name/display_name.dart';
import 'package:seeds/screens/authentication/sign_up/viewmodels/bloc.dart';

class SignupScreen extends StatelessWidget {
  final String? mnemonic;
  const SignupScreen(this.mnemonic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupBloc(
        deeplinkBloc: BlocProvider.of<DeeplinkBloc>(context),
        claimInviteUseCase: ClaimInviteUseCase(SignupRepository()),
        createUsernameUseCase: CreateUsernameUseCase(signupRepository: SignupRepository()),
        createAccountUseCase: CreateAccountUseCase(
          signupRepository: SignupRepository(),
          firebaseUserRepository: FirebaseUserRepository(),
        ),
      )..add(OnInviteCodeFromDeepLink(mnemonic)),
      child: BlocBuilder<SignupBloc, SignupState>(
        buildWhen: (previous, current) => previous.signupScreens != current.signupScreens,
        builder: (_, state) {
          final SignupScreens signupScreens = state.signupScreens;
          switch (signupScreens) {
            case SignupScreens.claimInvite:
              return const ClaimInviteScreen();
            case SignupScreens.displayName:
              return const DisplayName();
            case SignupScreens.username:
              return const CreateUsername();
          }
        },
      ),
    );
  }
}
