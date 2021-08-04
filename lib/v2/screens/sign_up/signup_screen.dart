import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/blocs/deeplink/viewmodels/deeplink_bloc.dart';
import 'package:seeds/v2/datasource/remote/api/signup_repository.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_user_repository.dart';
import 'package:seeds/v2/screens/sign_up/add_phone_number/add_phone_number.dart';
import 'package:seeds/v2/screens/sign_up/add_phone_number/usecases/add_phone_number_usecase.dart';
import 'package:seeds/v2/screens/sign_up/claim_invite/claim_invite_screen.dart';
import 'package:seeds/v2/screens/sign_up/claim_invite/usecases/claim_invite_usecase.dart';
import 'package:seeds/v2/screens/sign_up/create_username/create_username.dart';
import 'package:seeds/v2/screens/sign_up/create_username/usecases/create_username_usecase.dart';
import 'package:seeds/v2/screens/sign_up/display_name/display_name.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/bloc.dart';

class SignupScreen extends StatelessWidget {
  final String? Mnemonic;
  const SignupScreen(this.Mnemonic);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupBloc(
        deeplinkBloc: BlocProvider.of<DeeplinkBloc>(context),
        claimInviteUseCase: ClaimInviteUseCase(signupRepository: SignupRepository()),
        createUsernameUseCase: CreateUsernameUseCase(signupRepository: SignupRepository()),
        addPhoneNumberUseCase: AddPhoneNumberUseCase(
          signupRepository: SignupRepository(),
          firebaseUserRepository: FirebaseUserRepository(),
        ),
      )..add(OnInviteCodeFromDeepLink(inviteCode: Mnemonic)),
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
            case SignupScreens.phoneNumber:
              return const AddPhoneNumber();
          }
        },
      ),
    );
  }
}
